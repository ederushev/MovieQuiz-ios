//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Эдуард Дерюшев on 05.01.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (()-> Void)
}
