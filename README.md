# WellCSTV

iOS app that displays CS: GO matches happening across several worldwide tournaments

This documentation covers technologies, installation, usage, and project implementation. The project's definition is specified in the following links:
- Definition: https://fuzecc.notion.site/iOS-Challenge-EN-c27257e1ed0e47158d83508dd1e5f408
- Figma: https://www.figma.com/file/OeNVxV2YkHXMgzky8YNQQO/Desafio-CSTV?node-id=0%3A1
- API (PandaScore): https://developers.pandascore.co/reference/get_csgo_matches

## About the Project

The first task was to create Projects and the Board here on Github for task and requirement organization. The project can be found here: [WellCSTV 1.0.0](https://github.com/users/wnhirsch/projects/8).

The project's GitFlow works as follows:
- `main` is the main branch that contains the same code as the one in production.
- `develop` is the development branch that aggregates all different new features.
- `#XXX` are task branches where `#XXX` is the task number on the Board.
- All merges upward in the hierarchy (`main` > `develop` > `#XXX`) should be done via Pull Requests.

## Technologies

- **Language / UI Builder**: Swift with SwiftUI
- **IDE**: Xcode
- **Design Pattern**: MVVM
- **Native Frameworks**: Combine
- **Third-Party Frameworks**: SPM importing Alamofire and Moya
- **Testing**: Unit Testing with XCTest

## Implementation

I chose to use SwiftUI with MVVM to ensure the best code organization and facilitate screen construction. The project's organization is divided into the following directories:
- **API**: Contains all API configurations and request definitions.
- **Application**: Contains the main entities for application initialization.
- **Features**: Contains the application's flows. Each directory within this group represents a flow, and within each flow, there are definitions for each of its screens and other global auxiliary files, such as Models and Workers. For each screen, there is a View and a ViewModel, and there may also be components that would be classified as SubViews.
- **Utilities**: Contains various auxiliary entities that can be used in any context of the App, such as Extensions, UI Components, Protocols, among others.
- **Resources**: Contains various constant files that can be used in any context of the App, such as Localizables, Assets, and Fonts.

The application starts with the SplashScreen, which redirects to the MatchListView, our main screen, after 1 second. From there, the API data is loaded using its respective ViewModel. The user can reload or load more data, and by clicking on one of the cards, they will be redirected to the MatchDetailsView. This screen requires the respective Match for initialization, and from there, using its respective ViewModel, it loads the players' data for each team from the API.

## API

Only two APIs were used:
- `[GET] matches?sort=-begin_at&range[begin_at]={distant-past},{today}"&page={page}&pageSize={pageSize}`: Retrieves a list of Matches using pagination in descending order of the start date, starting from the current day 23:59:59 until the oldest computable day. The default page size is 10.
- `[GET] players?filter[team_id]={teamId}&page={page}&pageSize={pageSize}`: Retrieves a list of Players from a team using pagination. Due to the context where only players from a team would be fetched, I implemented support for pagination. However, in the MatchDetailsView, I request a single page with a size of 100, which already covers all players from a team.