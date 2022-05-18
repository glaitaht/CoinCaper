//
//  Variables.swift
//  GameDB
//
//  Created by Cem Kılıç on 11.03.2022.
//

import Foundation


public var firstLinkOfApiPage = "https://api.rawg.io/api/games?key=9bca2871fdbc4f4884de391b52215408"
public var gameDetailLink = "https://api.rawg.io/api/games/"
public var APIkey = "?key=9bca2871fdbc4f4884de391b52215408"
public var activePage = 0
public var noConnection = false

var serviceRequest = ServiceRequest()

var userDefaults = UserDefaults.standard
var favouriteGames = [Int]() 
