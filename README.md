# Usage
- Clone the repository and make sure to open the main branch
- Select a simulator or device to run the app on (minimum OS support iOS 14.0)
- To run the unit tests press Command + U on your keyboard

# Goal
- The goal was to build a scalable app that displays a list of products from an API
- The list is sorted by date with urgent announcements on top
- Each item in the list should have an image, a category, a title and a price
- A detail screen that displays the selected product with all the data available displayed
- Unit tests

# Pre-coding decisions made
- I have decided to build the project with the MVVM-C architecture. The reason for this is that this is one of the popular architectures that I have the most experience with as well as I find it a great architecture that allows us to implement good development practices.
- I wrote a few tests for the ListViewModel which is the main ViewModel that interacts with the Service
