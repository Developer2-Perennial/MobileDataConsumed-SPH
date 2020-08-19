# MobileDataConsumed-SPH
This MobileDataConsumed-SPH fetch and display the amount the of data sent over Singapore’s mobile networks.
Fetching the data from url https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&limit=200

# Minimum Deployment target

iOS 12.1

# How to use:
1. Clone the repository
2. Install Pod
3. Run application using Xcode

# Application workflow:
1. Application is develope using the MVVM architecture.
2. For designing UI used storyboard 
2. Used alamofire for api calling
3. Used realm Database for local cache.

![workFlow](https://github.com/Developer2-Perennial/MobileDataConsumed-SPH/blob/master/MobileDataRecorder_Diagram.pdf)

# How to Unit test:
  Added differrent target for UI and functinal Unit testing
  1. Mobile Data Usage Unit Tests
      This target is use to Unit test the viewcontroller, viewcontroller extension, viewModel, Database services and Network services. 
  2. Mobile Data UsageUITests
    This target is use to do UI testing.
    
Code coverge
![Code coverage](https://github.com/Developer2-Perennial/MobileDataConsumed-SPH/blob/master/Unit%20test%20coverage.png)

# Pod files 
1. Alamofire
    Use for network services calling.
2. RealmSwift
   Used realm Database for local cache.
3. MBProgressHUD
4. TTGSnackbar
   
