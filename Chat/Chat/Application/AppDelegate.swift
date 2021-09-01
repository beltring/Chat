//
//  AppDelegate.swift
//  Chat
//
//  Created by User on 8/20/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let vc = RootNavigationViewController()
        vc.setRootController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        changeTheme()
        
        TDManager.shared.coordinator.authorizationState.subscribe(on: .main) { event in
            guard let state = event.value else {
                return
            }
            switch state {
            case .waitTdlibParameters:
                print("Ignore these! TDLib-iOS will handle them.")
            case .waitEncryptionKey:
                print("Wait encryption key")
            case .waitPhoneNumber:
                print("Wait phone number event.")
            case .waitCode(_):
                print("Wait code event.")
            case .waitPassword( _, _, _):
                print("Show passoword screen (will only happen when the user has setup 2FA).")
            case .ready:
                print("Ready")
                AuthorizeData.shared.isAuthorized = true
            case .loggingOut, .closing, .closed:
                break
            case .waitOtherDeviceConfirmation(link: _):
                print("Wait other device confirmation")
            case .waitRegistration(termsOfService: _):
                print("Wait registration")
            }
        }
        
        return true
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Chat")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

// MARK: Extensions
extension AppDelegate {
    func changeTheme() {
        if #available(iOS 13.0, *) {
            let appearance = DataUDManager.shared.appearance
            UIApplication.shared.windows.forEach { window  in
                window.overrideUserInterfaceStyle = appearance == "light" ? .light : .dark
            }
        }
    }
}
