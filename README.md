# KiyizGroup Delivery App 🛍️🇰🇬✨
This mobile application provides a convenient way to browse, order, and manage items right from your mobile phone.

You can download the app here: [Download the app here](https://apps.apple.com/pt/app/kiyizgroup/id6502351648)

## Key Features:
- **Catalog Browsing:**
  
  Explore a wide range of products through a convenient mobile interface.
  
<p align="left">
  <img src="https://i.giphy.com/media/v1.Y2lkPTc5MGI3NjExaDM4ZnV6MWI0NmhuNzBoZjZxdXhub3Vwd2JoYWRncWFxYWR5MGYxcyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/qVs20vPT4EDkp0Qm0k/giphy.gif" alt="Alt Text">
</p>

- **Registration:**

Fast and convenient registration via email will allow you to quickly place your order.

![Alt Text](https://i.giphy.com/media/v1.Y2lkPTc5MGI3NjExdjhiNDMwNTIyZzBscDlscXh0Zjg3enRvMmFybXdic3d3NTM2bHAxYiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/HrDf9L8ldIxb2U5WaW/giphy.gif)

- **Order Placement:**
  
Easily and quickly place orders for the products you like directly from the application, minimizing the effort of searching and purchasing.

![Alt Text](https://i.giphy.com/media/v1.Y2lkPTc5MGI3NjExZGJ2OGtycTYxeXhvcDFjdWp2dnN0cGZiaGx3MDN4ZnNicjJiYjZ6dSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/pee1KS8bh7BAu7w52D/giphy.gif)


- **User information:**

Track your order history in your profile.

![Alt Text](https://i.giphy.com/media/v1.Y2lkPTc5MGI3NjExNHZpb3Jia2RtYTNkZTBreDg2ZnFoemkyNzk0ejZubTNndGxiNmo5ayZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/xoy6q3oqGG8Uu26DNz/giphy.gif)


- **Order Management (for administrators):**
  
  Administrators have a dedicated application for efficient order management and adding new products to the inventory.

![Alt Text](https://i.giphy.com/media/v1.Y2lkPTc5MGI3NjExa2kxbG92c2prbThkanczc2F5YnB1cm14bGFtNmdlYWppaHl1M2Y5eCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/HV9B40aah5WUcDk3io/giphy.gif)

## Requirements
- **iOS Platform:** iOS 14.0 
- **Swift Version:** Swift 5.5
- **Xcode Version:** Xcode 13.0
- **Dependency Manager:** Swift Package Manager (SPM)

### External Libraries:

- **SnapKit:** Used for declarative Auto Layout. [SnapKit GitHub](https://github.com/SnapKit/SnapKit)
- **Firebase:** Used for backend services, authentication, and more. [Firebase iOS Docs](https://firebase.google.com/docs/ios)
- **SDWebImage:** Used for asynchronous image loading and caching. [SDWebImage GitHub](https://github.com/SDWebImage/SDWebImage)

## Installation

1. Clone the repository: https://github.com/Anastasiia741/delivery-app.git 
2. Navigate to the project folder: cd StroybazaDeliveryApp
3. Open the project in Xcode: open StroybazaDeliveryApp.xcodeproj
4. Press `Cmd + R` to run the application.

## MVVM Architecture

This project adopts the Model-View-ViewModel (MVVM) architecture for application logic.

- **Model:**
The Model represents the data and business logic of the application. It is responsible for handling data storage, retrieval, and manipulation. In an MVVM architecture, the Model notifies the ViewModel of any changes in the data.
- **View:**
 The View is responsible for displaying the user interface and presenting data to the user. It observes the ViewModel for any updates and reflects changes in the UI. The View is declarative and focuses solely on presentation, without containing business logic.
- **ViewModel:**
 The ViewModel acts as an intermediary between the Model and the View. It receives user input from the View, processes it as needed, and updates the Model accordingly. The ViewModel also exposes data and commands to the View, allowing for binding and easy data synchronization. It ensures a separation of concerns by managing the application's logic and state, while the View remains focused on displaying the UI.

