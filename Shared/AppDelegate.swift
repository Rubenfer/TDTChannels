//
//  AppDelegate.swift
//  TDTOnline
//
//  Created by Ruben Fernandez on 02/07/2019.
//  Copyright © 2019 Ruben Fernandez. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let tvViewController = EmisionViewController(url: "http://www.tdtchannels.com/lists/channels.m3u8")
        tvViewController.tabBarItem = UITabBarItem(title: "TV", image: UIImage(systemName: "tv"), tag: 0)
        
        let radioViewController = EmisionViewController(url: "http://www.tdtchannels.com/lists/radio_channels.m3u8")
        radioViewController.tabBarItem = UITabBarItem(title: "Radio", image: UIImage(systemName: "tv.music.note"), tag: 1)
        
        let programacionViewController = ProgramacionMainViewController()
        programacionViewController.tabBarItem = UITabBarItem(title: "Programación", image: UIImage(systemName: "list.bullet"), tag: 2)
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([tvViewController, radioViewController,  programacionViewController], animated: false)
        let mainNavigationController = UINavigationController(rootViewController: tabBarController)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = mainNavigationController
        window?.makeKeyAndVisible()
        
        return true
        
    }
    
    #if targetEnvironment(macCatalyst)
    override func buildMenu(with builder: UIMenuBuilder) {
        super.buildMenu(with: builder)
        builder.remove(menu: .format)
        builder.remove(menu: .services)
        builder.remove(menu: .toolbar)
        builder.remove(menu: .edit)
        builder.remove(menu: .file)
        builder.remove(menu: .help)
        builder.remove(menu: .about)
    }
    #endif
    
}

