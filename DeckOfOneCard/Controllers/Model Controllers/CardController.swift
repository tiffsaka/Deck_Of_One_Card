//
//  CardController.swift
//  DeckOfOneCard
//
//  Created by Tiffany Sakaguchi on 5/4/21.
//  Copyright © 2021 Warren. All rights reserved.
//

import UIKit

class CardController {
    
    static let baseURL = URL(string: "https://deckofcardsapi.com/api/deck/new/draw/")
    
    static func fetchCard(completion: @escaping (Result<Card, CardError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}

        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let countQuery = URLQueryItem(name: "count", value: "1")
        components?.queryItems = [countQuery]
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL))}
        print("FINAL URL: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            if let response = response as? HTTPURLResponse {
                print("STATUS CODE: \(response.statusCode)")
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                guard let card = topLevelObject.cards.first else { return }
                completion(.success(card))
            } catch {
                completion(.failure(.thrownError(error)))
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }.resume()
    }
    
    
    static func fetchImage(for card: Card, completion: @escaping (Result <UIImage, CardError>) -> Void) {
        
        let url = card.image
        //guard let url = card.images else { return completion(.failure(.noData))}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            if let response = response as? HTTPURLResponse {
                print("IMAGE STATUS CODE: \(response.statusCode)")
            }
            
            guard let data = data else { return completion(.failure(.noData))}
            
            guard let cardImage = UIImage(data: data) else {
                return completion(.failure(.unableToDecode))
            }
            completion(.success(cardImage))
            
        }.resume()
        
        
        
    }
    
    
}
