# OrbitNews

**OrbitNews** is a test application for Mercado Libre that provides users with the latest space-related news from the Spaceflight News API. The app features infinite scrolling for continuous content discovery, the ability to save favorite articles, and seamless article viewing through an integrated WebView.

## Features

- **Real-time News Feed**: Fetches the latest space news articles from the Spaceflight News API.
- **Infinite Scrolling**: Automatically loads more articles as users scroll through the content.
- **Dual View Modes**: Toggle between list view and 2x2 grid layout for different browsing experiences.
- **Favorites System**: Users can mark articles as favorites from the detail view, which are stored locally in an SQLite database for persistent access.
- **Search Functionality**: Context-aware search that filters content based on the current tab (news or favorites).
- **Integrated Article Viewer**: Full article content displayed via an embedded WebView component.
- **Article Sharing**: Share interesting articles directly from within the app.
- **Custom TabBar**: Navigate between News, Search, and Favorites sections through a custom-designed TabBar.
- **Localization**: Full support for English and Spanish languages using Apple's String Catalog system.

## Technical Details

- **Modern Swift Implementation**: Built with Swift 6 and SwiftUI for iOS 16.6+
- **Asynchronous Operations**: Uses Swift's modern async/await pattern for network calls and data handling.
- **Local Storage**: SQLite database manages favorite articles for persistence across sessions.
- **Bridged Components**: UIKit's WebView integrated into SwiftUI using UIViewRepresentable.
- **Animation**: Incorporates Lottie animations for engaging splash screen and loading states.
- **Apple Documentation Structure**: Follows Apple's recommended documentation practices.
- **Localization**: Implements String Catalog for seamless language switching between English and Spanish.

## Architecture

The app is structured following modern iOS development principles:

1. **UI Layer**: SwiftUI-based views with responsive layouts.
2. **Data Management**: Asynchronous data fetching with proper error handling.
3. **Storage Layer**: SQLite implementation for local data persistence.
4. **Bridge Components**: UIKit to SwiftUI integration for specialized functionality.
5. **Localization Layer**: String Catalog implementation for multi-language support.

## Requirements

- iOS 16.6 or later
- Swift 6
- Xcode 15+

## Dependencies

- **Lottie**: Used for JSON-based animations in splash screen and loading states.

## Testing

The application includes comprehensive test coverage:

- **Unit Tests**: Validates core functionality and business logic.
- **XCTest**: Automated UI testing to ensure proper user interaction flows.

## Views

The app consists of several interconnected views organized through a custom TabBar:

1. **Main Feed View**: Displays articles in either list or grid format with options to:
   - Toggle between list and 2x2 grid layouts
   - Load more content through infinite scrolling
   
2. **Search View**: Dynamic search interface that:
   - Appears when the search tab is selected or search is activated
   - Adapts search results based on current context (news or favorites)
   - Replaces the main content area when active

3. **Favorites View**: Shows user-saved articles with similar layout options as the main feed.
   
4. **Article Detail View**: Presented as a sheet that includes:
   - WebView displaying the full article content
   - Share functionality
   - Option to add/remove from favorites

## Navigation

The app uses a custom TabBar that provides access to three main sections:
- **News**: The main feed of articles from the API
- **Search**: Context-aware search functionality
- **Favorites**: Collection of user-saved articles

The search functionality is integrated such that when activated, it replaces the current view with a search interface that filters results based on the active tab (either news or favorites).

## Localization

OrbitNews offers full localization support for:
- English
- Spanish

The implementation uses Apple's String Catalog system, allowing for:
- Seamless language switching based on device settings
- Proper formatting of dates, numbers, and special terms
- Complete translation of all UI elements and error messages
- Culturally appropriate content presentation

## Future Enhancements

Potential areas for future development include:

- Additional language support beyond English and Spanish
- Push notifications for breaking news
- Offline reading capability
- Dark mode optimization
