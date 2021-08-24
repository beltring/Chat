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
        
        TDManager.shared.coordinator.authorizationState.subscribe(on: .main) { [weak self] event in
            guard let state = event.value else {
                return
            }
            switch state {
            case .waitTdlibParameters, .waitEncryptionKey:
            // Ignore these! TDLib-iOS will handle them.
            print("Ignore these! TDLib-iOS will handle them.")
            case .waitPhoneNumber:
            // Show sign in screen.
//                TDManager.shared.setPhoneNumber(number: "+37529734598")
                print("Show sign in screen.")
//                self?.window?.rootViewController = PhoneNumberViewController.initial()
            case .waitCode(let codeInfo):
            // Show code input screen.
                print(codeInfo)
                print("Show code input screen.")
            case .waitPassword(let passwordHint, _, _):
            // Show passoword screen (will only happen when the user has setup 2FA).
                print("Show passoword screen (will only happen when the user has setup 2FA).")
            case .ready:
            // Show main view
                print("Show main view.")
                AuthorizeData.shared.isAuthorized = true
            case .loggingOut, .closing, .closed:
                break
            case .waitOtherDeviceConfirmation(link: let link):
                print(".waitOtherDeviceConfirmation")
            case .waitRegistration(termsOfService: let termsOfService):
                print("waitRegistration")
            }
        }
            
            return true
        }
        
        // MARK: - Core Data stack
        
        lazy var persistentContainer: NSPersistentContainer = {
            /*
             The persistent container for the application. This implementation
             creates and returns a container, having loaded the store for the
             application to it. This property is optional since there are legitimate
             error conditions that could cause the creation of the store to fail.
             */
            let container = NSPersistentContainer(name: "Chat")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
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
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
        
    }

