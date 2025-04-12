# Run for It

**Run for It** is a Swift-based running app that helps users track their runs, monitor performance, and analyze their running history. Designed for runners of all levels, the app provides real-time stats, an intuitive interface, and a seamless experience for logging and reviewing runs.

---

## **Features**

### **1. Real-time Run Tracking**
- Track your **distance**, **duration**, **pace**, and **average speed** while running.
- View your running route in real-time on an interactive map.

### **2. Historical Data**
- Save your running stats and routes locally.
- Access a detailed history of all your runs, complete with:
  - Date and time of the run.
  - Distance covered.
  - Duration and average speed.
  - A map screenshot of the route.

### **3. Intuitive User Interface**
- Minimalist design for easy navigation.
- Two main tabs for quick access:
  - **Run Tab**: Start a new run.
  - **History Tab**: Review previous runs.

### **4. Expandable Features**
- Future integration with **CloudKit** for cross-device data sync and sharing.
- Social features, including group challenges and performance comparisons.

---

## **Technical Overview**

### **Technology Stack**
- **Swift** & **SwiftUI**: For app development and user interface.
- **MapKit**: For map rendering and real-time route tracking.
- **Core Location**: For GPS-based tracking of user movement.
- **UIGraphicsImageRenderer**: For capturing route screenshots.
- **MVVM Architecture**: Ensuring scalability and maintainability.

### **Key Components**
- **RunViewModel.swift**: Handles business logic, including tracking, statistics calculations, and data persistence.
- **MapView.swift**: A custom `UIViewRepresentable` that integrates with MapKit to display the user's route.
- **Views**: SwiftUI views for the app's user interface, including `RunView`, `HomeView`, `HistoryView`, and `HistoryDetailView`.

---

## **How to Use**

### **1. Installation**
1. Clone the repository:  
   ```bash
   git clone https://github.com/tarik-bratic/RunforIt.git
   ```
2. Open the project in **Xcode**.
3. Build and run the app on your simulator or physical device.

### **2. Running the App**
- Launch the app to access the **Home Screen**.
- **Start a Run**:  
  - Tap "Start Run" to begin tracking.
  - Swipe between real-time stats and the route map during your run.
- **Stop and Save**:  
  - Tap "Stop" to save your run and add it to your history.
- **View History**:  
  - Navigate to the "Previously" tab to review your past runs.

---

## **Screenshots**

| **Home View** | **Run View** | **Map View** |
|--------------|------------------|-----------------------|
| <img src="https://github.com/user-attachments/assets/590fa265-77fb-4fbe-94ad-1d840b1de1f2" width="200" /> | <img src="https://github.com/user-attachments/assets/43d57a3a-dea4-4972-96ea-d96cd0b6608e" width="200" /> | <img src="https://github.com/user-attachments/assets/f2a57200-c5a4-404c-a78a-109748b4f5de" width="200" /> |

## **Videos**
<img src="https://github.com/user-attachments/assets/5641093e-aa10-4db7-802b-822e9e066947" width="200"/>

---

## **Future Improvements**
1. **CloudKit Integration**: Sync run history across devices.
2. **Social Features**: Share runs, challenge friends, and view leaderboards.
3. **Enhanced Analytics**: Provide more detailed performance insights.

---

## **Contributing**
Contributions are welcome! To contribute:  
1. Fork the repository.  
2. Create a new branch for your feature or fix.  
3. Submit a pull request detailing your changes.

---

## **License**
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## **Contact**
For questions or feedback, feel free to reach out:  
**Tarik Bratic** – *tarikbratic@gmx.com*
