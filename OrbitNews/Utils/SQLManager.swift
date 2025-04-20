//
//  SQLManager.swift
//  OrbitNews
//
//  Created by Christians bonilla on 19/04/25.
//

import SQLite3
import Foundation
import Combine

/// A manager class responsible for handling all SQLite database operations related to storing and retrieving favorite locations.
///
/// This class encapsulates the logic for interacting with the SQLite database, providing methods to perform CRUD (Create, Read, Update, Delete)
/// operations on favorite locations. It ensures proper initialization of the database connection and handles any potential errors during these operations.
///
/// - Note: The database connection must be properly initialized before performing any operations. Ensure that the `db` property is set up correctly.
///
/// Usage:
/// ```swift
/// let sqlManager = SQLManager()
/// ```
///
class SQLManager: ObservableObject {
    
    var db: OpaquePointer?
    @Published var favorites: [ResultsArticles] = []
    
    /// Initializes the `SQLManager` and opens the database connection.
    ///
    /// This initializer sets up the `SQLManager` instance by calling the `openDatabase()` method,
    /// which ensures the SQLite database is opened and the `Favorites` table is created if it does not already exist.
    ///
    /// - Important: Ensure that the `openDatabase()` method is implemented and functional before using this initializer.
    ///
    /// ```swift
    /// let sqlManager = SQLManager()
    /// // Prints: "Successfully opened database at <file_path>" if the operation succeeds.
    /// ```
    init() {
        openDatabase()
        
    }
    
    
    /// Opens a connection to the SQLite database and performs necessary configurations.
    ///
    /// This function attempts to open a SQLite database located in the app's documents directory. If the database does not exist, it is created automatically.
    /// After opening the database, this function configures it for better performance and concurrency by enabling Write-Ahead Logging (WAL) mode and setting a busy timeout.
    /// It also calls `createFavoritesTable` to ensure the necessary table structure exists.
    ///
    /// - Important: Ensure that the `db` property is properly declared and initialized elsewhere in the class or struct.
    ///              Additionally, handle errors gracefully in production code instead of using `try!` for file URL creation.
    ///
    /// Example usage:
    ///
    /// ```swift
    /// openDatabase()
    /// ```
    func openDatabase() {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("LocationDatabase.sqlite")
        
        if sqlite3_open_v2(fileURL.path, &db, SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Error opening database: \(errorMessage)")
            return
        } else {
            print("Successfully opened database at \(fileURL.path)")
        }
        
        if sqlite3_exec(db, "PRAGMA journal_mode=WAL;", nil, nil, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Failed to set WAL mode: \(errorMessage)")
        } else {
            print("WAL mode enabled for better concurrency.")
        }
        
        if sqlite3_busy_timeout(db, 5000) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Failed to set busy timeout: \(errorMessage)")
        }
        
        createFavoritesTable()
    }

    
    /// Creates the `Favorites` table in the database if it does not already exist.
    ///
    /// This method executes a SQL `CREATE TABLE IF NOT EXISTS` statement to ensure the `Articles` table
    /// is present in the database. The table includes columns for storing article details such as `id`,
    /// `title`, `url`, `image_url`, `news_site`, `summary`, `published_at`, `updated_at`, and `featured`.
    ///
    /// If the table creation is successful, a confirmation message is printed. Otherwise, an error message
    /// is displayed, including details about the failure.
    ///
    /// - Important: Ensure the database connection (`db`) is properly initialized before calling this method.
    ///
    /// ```swift
    /// createFavoritesTable()
    /// // Prints: "Favorites table created." if the operation succeeds.
    /// ```
    func createFavoritesTable() {
        let createTableString = """
        CREATE TABLE IF NOT EXISTS Articles (
            id INTEGER PRIMARY KEY,
            title TEXT,
            url TEXT,
            image_url TEXT,
            news_site TEXT,
            summary TEXT,
            published_at TEXT,
            updated_at TEXT,
            featured INTEGER, 
            autors TEXT
        );
        """
        
        var createTableStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Favorites table created.")
                self.fetchAllFavorites()
            } else {
                print("Favorites table could not be created.")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("CREATE TABLE statement could not be prepared: \(errorMessage)")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    /// Inserts a location into the `Favorites` table.
    ///
    /// - Parameter article: A `ResultsArticles` object representing the article to be inserted or replaced in the `Favorites` table.
    ///
    /// This method performs a SQL `INSERT OR REPLACE` operation to add or update an article in the `Favorites` table.
    /// Each property of the `ResultsArticles` object is bound to the corresponding column in the database.
    /// The `published_at` date is formatted using the ISO8601 format before being inserted.
    ///
    /// If the insertion is successful, a confirmation message is printed. Otherwise, an error message is displayed.
    ///
    /// - Important: Ensure the database connection (`db`) is properly initialized before calling this method.
    ///
    /// ```swift
    /// let article = ResultsArticles(
    ///     id: 42,
    ///     title: "Sample Article",
    ///     authors: nil,
    ///     url: "https://example.com",
    ///     image_url: "https://example.com/image.jpg",
    ///     news_site: "Example News",
    ///     summary: "This is a sample article.",
    ///     published_at: Date(),
    ///     updated_at: "2023-10-01T12:00:00Z",
    ///     featured: true,
    ///     launches: nil,
    ///     events: nil
    /// )
    /// insertFavorites(article: article)
    /// // Prints: "Successfully inserted favorites." if the operation succeeds.
    /// ```
    func insertFavorites(article: ResultsArticles) {
        
        let cleanArticle = sanitizeArticle(article)
        
        let insertStatementString = """
                INSERT OR REPLACE INTO Articles (id, title, url, image_url, news_site, summary, published_at, updated_at, featured, autors)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
                """
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(insertStatement, 1, Int32(cleanArticle.id))
            
            let title = cleanArticle.title ?? ""
            safeBindText(insertStatement, 2, title)
            
            let url = cleanArticle.url ?? ""
            safeBindText(insertStatement, 3, url)
            
            let imageUrl = cleanArticle.image_url ?? ""
            safeBindText(insertStatement, 4, imageUrl)
            
            let newsSite = cleanArticle.news_site ?? ""
            safeBindText(insertStatement, 5, newsSite)
            
            let summary = cleanArticle.summary ?? ""
            safeBindText(insertStatement, 6, summary)
            
            let isoFormatter = ISO8601DateFormatter()
            let publishedString: String
            if let publishedDate = cleanArticle.published_at {
                publishedString = isoFormatter.string(from: publishedDate)
            } else {
                publishedString = ""
            }
            safeBindText(insertStatement, 7, publishedString)
            
            let updatedAt = cleanArticle.updated_at ?? ""
            safeBindText(insertStatement, 8, updatedAt)
            
            let featuredValue = cleanArticle.featured == true ? 1 : 0
            sqlite3_bind_int(insertStatement, 9, Int32(featuredValue))
            
            let authors = cleanArticle.authors?.first
            safeBindText(insertStatement, 10, authors?.name ?? "")
            
            let result = sqlite3_step(insertStatement)
            if result == SQLITE_DONE {
                print("Successfully inserted article with ID: \(cleanArticle.id)")
                favorites.append(article)
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("Error inserting article (code \(result)): \(errorMessage)")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Error preparing INSERT statement: \(errorMessage)")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    
    /// Determines whether a given Unicode scalar represents a control character.
    ///
    /// - Parameter scalar: The `UnicodeScalar` to evaluate.
    ///
    /// - Returns: `true` if the scalar is a control character, otherwise `false`.
    ///
    /// A control character is defined as any Unicode scalar with a value in the ranges:
    /// - `0x00` to `0x1F` (C0 controls), or
    /// - `0x7F` to `0x9F` (C1 controls).
    ///
    /// Control characters are non-printable characters typically used for formatting or control purposes.
    ///
    /// Example:
    /// ```swift
    /// let tab = UnicodeScalar(9)!
    /// let letterA = UnicodeScalar(65)!
    /// print(isControlCharacter(tab))       // true
    /// print(isControlCharacter(letterA))   // false
    /// ```
    func isControlCharacter(_ scalar: UnicodeScalar) -> Bool {
        let value = scalar.value
        return (value <= 0x1F) || (value >= 0x7F && value <= 0x9F)
    }
    
    /// Sanitizes the properties of a `ResultsArticles` object to ensure they are safe for use.
    ///
    /// - Parameter article: The `ResultsArticles` object to sanitize.
    ///
    /// - Returns: A new `ResultsArticles` object with sanitized string properties.
    ///
    /// This function creates a new `ResultsArticles` instance by sanitizing specific string properties
    /// of the input `article`. The sanitization process is applied to the following properties:
    /// - `title`
    /// - `url`
    /// - `image_url`
    /// - `news_site`
    /// - `summary`
    /// - `updated_at`
    ///
    /// Non-string properties and properties not requiring sanitization (e.g., `id`, `authors`, `published_at`, etc.)
    /// are copied directly from the original `article`.
    ///
    /// - Note: The `sanitizeString` function is used internally to perform the sanitization of individual strings.
    ///
    /// Example:
    /// ```swift
    /// let originalArticle = ResultsArticles(...)
    /// let sanitizedArticle = sanitizeArticle(originalArticle)
    /// print(sanitizedArticle.title) // Outputs the sanitized title
    /// ```
    func sanitizeArticle(_ article: ResultsArticles) -> ResultsArticles {
        return ResultsArticles(
            id: article.id,
            title: sanitizeString(article.title),
            authors: article.authors,
            url: sanitizeString(article.url),
            image_url: sanitizeString(article.image_url),
            news_site: sanitizeString(article.news_site),
            summary: sanitizeString(article.summary),
            published_at: article.published_at,
            updated_at: sanitizeString(article.updated_at),
            featured: article.featured,
            launches: article.launches,
            events: article.events,
            isFavorite: article.isFavorite,
        )
    }
    
    /// Sanitizes a given string by removing control characters.
    ///
    /// - Parameter string: The string to sanitize. If `nil`, the function returns `nil`.
    ///
    /// - Returns: A sanitized string with all control characters removed, or `nil` if the input is `nil`.
    ///
    /// This function filters out any control characters from the input string. Control characters are defined as:
    /// - Unicode scalars in the range `0x00` to `0x1F` (C0 controls), or
    /// - Unicode scalars in the range `0x7F` to `0x9F` (C1 controls).
    ///
    /// Characters that are not control characters are retained in the resulting string. If the input string is `nil`,
    /// the function gracefully handles it by returning `nil`.
    ///
    /// - Important: The function relies on the `isControlCharacter` utility to identify control characters.
    ///
    /// Example:
    /// ```swift
    /// let input = "Hello\u{0000}World!\u{001F}"
    /// let sanitized = sanitizeString(input)
    /// print(sanitized ?? "") // Outputs: "HelloWorld!"
    /// ```
    func sanitizeString(_ string: String?) -> String? {
        guard let string = string else { return nil }
        return string.filter { char in
            guard let scalar = char.unicodeScalars.first else { return false }
            return !isControlCharacter(scalar)
        }
    }
    
    /// Safely binds a text value to a parameter in an SQLite prepared statement.
    ///
    /// - Parameters:
    ///   - statement: The SQLite prepared statement (`OpaquePointer?`) to which the text will be bound.
    ///   - index: The index of the parameter in the SQL query to bind the text to.
    ///   - text: The text value to bind. If the text is empty, `NULL` will be bound instead.
    ///
    /// This function ensures safe binding of text values to SQLite statements. If the provided text is empty,
    /// it binds `NULL` to the specified parameter index. Otherwise, it binds the text as a UTF-8 encoded string.
    ///
    /// - Important: The `statement` must be a valid prepared SQLite statement, and the `index` must correspond
    ///   to a valid parameter index in the SQL query.
    ///
    /// Example:
    /// ```swift
    /// let query = "INSERT INTO Articles (title, summary) VALUES (?, ?);"
    /// var statement: OpaquePointer?
    /// if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
    ///     safeBindText(statement, 1, "New Article Title")
    ///     safeBindText(statement, 2, "") // Binds NULL for an empty summary
    ///     sqlite3_step(statement)
    /// }
    /// sqlite3_finalize(statement)
    /// ```
    func safeBindText(_ statement: OpaquePointer?, _ index: Int32, _ text: String) {
        if text.isEmpty {
            sqlite3_bind_null(statement, index)
        } else {
            sqlite3_bind_text(statement, index, (text as NSString).utf8String, -1, nil)
        }
    }
    
    /// Fetches all favorite locations from the `Favorites` table.
    ///
    /// - Returns: An array of `ResultsArticles` objects representing all the articles stored in the `Favorites` table.
    ///
    /// This method performs a SQL `SELECT` query to retrieve all records from the `Favorites` table and maps
    /// each row to a `ResultsArticles` object. The date string is parsed using the ISO8601 format.
    ///
    /// If the query cannot be prepared or executed, an error message is printed to the console.
    ///
    /// - Important: Ensure the database connection (`db`) is properly initialized before calling this method.
    ///
    /// ```swift
    /// let favorites = fetchAllFavorites()
    /// print("Fetched \(favorites.count) favorite articles.")
    /// ```
    func fetchAllFavorites() {
        let queryStatementString = "SELECT * FROM Articles;"
        var queryStatement: OpaquePointer?
        var articles: [ResultsArticles] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(queryStatement, 0))
                let title = String(cString: sqlite3_column_text(queryStatement, 1))
                let url = String(cString: sqlite3_column_text(queryStatement, 2))
                let imageUrl = String(cString: sqlite3_column_text(queryStatement, 3))
                let newsSite = String(cString: sqlite3_column_text(queryStatement, 4))
                let summary = String(cString: sqlite3_column_text(queryStatement, 5))
                let publishedAtStr = String(cString: sqlite3_column_text(queryStatement, 6))
                let updatedAt = String(cString: sqlite3_column_text(queryStatement, 7))
                let featured = sqlite3_column_int(queryStatement, 8) == 1
                
                let formatter = ISO8601DateFormatter()
                let publishedAt = formatter.date(from: publishedAtStr)
                
                let article = ResultsArticles(
                    id: id,
                    title: title,
                    authors: nil,
                    url: url,
                    image_url: imageUrl,
                    news_site: newsSite,
                    summary: summary,
                    published_at: publishedAt,
                    updated_at: updatedAt,
                    featured: featured,
                    launches: nil,
                    events: nil,
                    isFavorite: true
                )
                articles.append(article)
            }
        } else {
            print("SELECT statement could not be prepared. Error: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        sqlite3_finalize(queryStatement)
        favorites = articles
    }
    
    /// Fetches an article from the database by its unique identifier.
    ///
    /// - Parameter id: The unique identifier of the article to fetch.
    ///
    /// - Returns: A `ResultsArticles` object if the article was found, or `nil` if no matching article exists.
    ///
    /// - Important: Ensure the database connection is properly initialized before calling this method.
    ///
    /// This method performs a direct SQL query and maps the database columns to the corresponding
    /// `ResultsArticles` properties. The date string is parsed using ISO8601 format.
    ///
    /// ```swift
    /// if let article = fetchArticle(by: 42) {
    ///     print("Found article: \(article.title)")
    /// }
    /// ```
    func fetchArticle(by id: Int) -> ResultsArticles? {
        let query = "SELECT * FROM Articles WHERE id = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(id))
            
            if sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                
                let title = safeColumnText(statement: statement, column: 1)
                let url = safeColumnText(statement: statement, column: 2)
                let imageUrl = safeColumnText(statement: statement, column: 3)
                let newsSite = safeColumnText(statement: statement, column: 4)
                let summary = safeColumnText(statement: statement, column: 5)
                let publishedAtStr = safeColumnText(statement: statement, column: 6)
                let updatedAt = safeColumnText(statement: statement, column: 7)
                let featured = sqlite3_column_int(statement, 8) == 1
                
                var publishedAt: Date? = nil
                if !publishedAtStr.isEmpty {
                    let formatter = ISO8601DateFormatter()
                    publishedAt = formatter.date(from: publishedAtStr)
                }
                
                let article = ResultsArticles(
                    id: id,
                    title: title,
                    authors: nil,
                    url: url,
                    image_url: imageUrl,
                    news_site: newsSite,
                    summary: summary,
                    published_at: publishedAt,
                    updated_at: updatedAt,
                    featured: featured,
                    launches: nil,
                    events: nil,
                    isFavorite: true
                )
                
                sqlite3_finalize(statement)
                return article
            }
        } else {
            print("SELECT error: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        sqlite3_finalize(statement)
        return nil
    }
    
    
    /// Searches for favorite articles in the database based on a keyword and updates the `favorites` property with the results.
    ///
    /// - Parameter keyword: A string representing the search term to match against article titles.
    ///
    /// This function performs a SQL query to search for articles in the `Articles` table where the title contains the provided keyword.
    /// The search is case-insensitive and supports partial matches using the SQL `LIKE` operator with wildcard characters (`%`).
    /// Each matching article is mapped to a `ResultsArticles` object, marked as a favorite (`isFavorite = true`), and stored in the `favorites` property.
    ///
    /// - Important: Ensure that the database connection (`db`) is properly initialized before calling this function.
    ///              Additionally, the `safeColumnText` helper function must be implemented to safely retrieve text values from the database.
    ///              The `favorites` property must be defined elsewhere in the class or struct to store the search results.
    ///
    /// Example usage:
    ///
    /// ```swift
    /// searchFavorites(by: "space")
    /// print("Found \(favorites.count) articles matching 'space'")
    /// ```
    func searchFavorites(by keyword: String) {
        let queryStatementString = "SELECT * FROM Articles WHERE title LIKE ?;"
        var queryStatement: OpaquePointer?
        var articles: [ResultsArticles] = []
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            let searchParam = "%\(keyword)%"
            sqlite3_bind_text(queryStatement, 1, (searchParam as NSString).utf8String, -1, nil)
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(queryStatement, 0))
                let title = safeColumnText(statement: queryStatement, column: 1)
                let url = safeColumnText(statement: queryStatement, column: 2)
                let imageUrl = safeColumnText(statement: queryStatement, column: 3)
                let newsSite = safeColumnText(statement: queryStatement, column: 4)
                let summary = safeColumnText(statement: queryStatement, column: 5)
                let publishedAtStr = safeColumnText(statement: queryStatement, column: 6)
                let updatedAt = safeColumnText(statement: queryStatement, column: 7)
                let featured = sqlite3_column_int(queryStatement, 8) == 1
                
                var publishedAt: Date? = nil
                if !publishedAtStr.isEmpty {
                    let formatter = ISO8601DateFormatter()
                    publishedAt = formatter.date(from: publishedAtStr)
                }
                
                let article = ResultsArticles(
                    id: id,
                    title: title,
                    authors: nil,
                    url: url,
                    image_url: imageUrl,
                    news_site: newsSite,
                    summary: summary,
                    published_at: publishedAt,
                    updated_at: updatedAt,
                    featured: featured,
                    launches: nil,
                    events: nil,
                    isFavorite: true
                )
                articles.append(article)
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Search statement could not be prepared. Error: \(errorMessage)")
        }
        
        sqlite3_finalize(queryStatement)
        favorites = articles
    }
    
    /// Safely retrieves and sanitizes text from a column in an SQLite prepared statement.
    ///
    /// - Parameters:
    ///   - statement: The SQLite prepared statement (`OpaquePointer?`) from which to retrieve the text.
    ///   - column: The index of the column in the result set to retrieve the text from.
    ///
    /// - Returns: A sanitized string containing the text from the specified column. If the column value is `NULL`
    ///   or cannot be retrieved, an empty string is returned.
    ///
    /// This function ensures safe retrieval of text from an SQLite query result. If the column value is `NULL` or
    /// the text cannot be retrieved, it returns an empty string. Otherwise, it converts the column value to a Swift
    /// `String` and sanitizes it by removing any control characters.
    ///
    /// - Important: The `statement` must be a valid prepared SQLite statement, and the `column` index must correspond
    ///   to a valid column in the result set. The function relies on `isControlCharacter` to filter out control characters.
    ///
    /// Example:
    /// ```swift
    /// let query = "SELECT title FROM Articles WHERE id = ?;"
    /// var statement: OpaquePointer?
    /// if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
    ///     sqlite3_bind_int(statement, 1, 42)
    ///     if sqlite3_step(statement) == SQLITE_ROW {
    ///         let title = safeColumnText(statement: statement, column: 0)
    ///         print("Article Title: \(title)")
    ///     }
    /// }
    /// sqlite3_finalize(statement)
    /// ```
    func safeColumnText(statement: OpaquePointer?, column: Int32) -> String {
        if sqlite3_column_type(statement, column) == SQLITE_NULL {
            return ""
        }
        
        guard let cString = sqlite3_column_text(statement, column) else {
            return ""
        }
        
        return String(cString: cString).filter { char in
            
            guard let scalar = char.unicodeScalars.first else { return false }
            return !isControlCharacter(scalar)
        }
    }
    
    /// Deletes a favorite location from the `Favorites` table by its ID.
    ///
    /// - Parameter id: The unique identifier of the favorite location to delete.
    ///
    /// This method executes a SQL `DELETE` statement to remove the record with the specified `id`
    /// from the `Favorites` table. If the deletion is successful, a confirmation message is printed.
    /// Otherwise, an error message is displayed.
    ///
    /// - Important: Ensure the database connection (`db`) is properly initialized before calling this method.
    ///
    /// ```swift
    /// deleteFavorite(by: 5)
    /// // Prints: "Successfully deleted favorites with id 5." if the operation succeeds.
    /// ```
    func deleteFavorite(by id: Int) {
        
        guard db != nil else {
            print("Database connection is nil")
            return
        }
        
        let deleteStatementString = "DELETE FROM Articles WHERE id = ?;"
        var deleteStatement: OpaquePointer?
        
        let result = sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil)
        if result == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted favorite with id \(id).")
                
                favorites.removeAll { $0.id == id }
                
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("Could not delete favorite: \(errorMessage)")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("DELETE statement could not be prepared: \(errorMessage)")
        }
        
        sqlite3_finalize(deleteStatement)
    }
}

