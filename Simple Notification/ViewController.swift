
import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        // get the permission first
        getUserPermission();
        
        // Simple Notification
        configureSimpleNotification()
        showSimpleNotification()
    }
    
    
    
    
    
    
    
    
    private func configureSimpleNotification() {
        UNUserNotificationCenter.current().delegate = self
        
        let action_1 = UNNotificationAction(identifier: "actId_1",
                                            title: "Read Later",
                                            options: [])
        let action_2 = UNNotificationAction(identifier: "actId_2",
                                            title: "Show Details",
                                            options: [.foreground])
        
        let myCategory = UNNotificationCategory(identifier: "catId",
                                                actions: [action_1, action_2],
                                                intentIdentifiers: [],
                                                options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([myCategory])
    }
    
    
    
    
    
    
    
    
    
    func showSimpleNotification() {
        let simpleTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 8,
                                                              repeats: false)
        let simpleContent = UNMutableNotificationContent()
        simpleContent.title = "Simple Notification"
        simpleContent.body = "This should happen in 8\"!"
        simpleContent.sound = UNNotificationSound.default()
        
        simpleContent.categoryIdentifier = "catId"
        
        
        
        let path = Bundle.main.path(forResource: "cinard",
                                    ofType: "png")
        
        let url = URL(fileURLWithPath: path!)
        
        do {
            let attachment = try UNNotificationAttachment(identifier: "simpleIdentifier",
                                                          url: url,
                                                          options: nil)
            simpleContent.attachments = [attachment]
        } catch {
            print("Error with attachement")
        }

        
        let request = UNNotificationRequest(identifier:"simpleId",
                                            content: simpleContent,
                                            trigger: simpleTrigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("error with request: \(error)")
            }
        }
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ( segue.identifier == "goSegue")
        {
            // we reached there through notification
            
        }
    }
    
    
    
    // delegate methods
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "actId_1":
            print("Action one")
        //
        case "actId_2":
            print("Action two")
            self.performSegue(withIdentifier: "goSegue",
                              sender: nil)
        default:
            print("Other Action")
        }
        completionHandler()
    }
    
    
    
    
    
    
    
    
    func getUserPermission()
    {
        // grant access by user to receve notifications
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .sound])
            {
                (accepted, error) in
                var alert : UIAlertController;
                
                
                if !accepted
                {
                    alert = UIAlertController(title: "Denied",
                                              message: "Notification access denied.",
                                              preferredStyle: UIAlertControllerStyle.alert);
                }
                else
                {
                    alert = UIAlertController(title: "Granted",
                                              message: "Notification access granted.",
                                              preferredStyle: UIAlertControllerStyle.alert);
                }
                alert.addAction(UIAlertAction(title: "Ok",
                                              style: UIAlertActionStyle.default,
                                              handler: nil))
                
                self.present(alert, animated: true, completion: nil)
        }
    }
}

