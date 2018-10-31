//
//  Constants.swift
//  flight.wallet
//
//  Created by Aleksey Bykhun on 28/10/2018.
//  Copyright © 2018 Aleksey Bykhun. All rights reserved.
//

import Foundation

enum Network {
    case Mainnet
    case Testnet
}

enum Chain {
    case Bitcoin
    case Ethereum
    case Other
}

struct Address {
    let network: Network
    let type: Chain
    let path: String
    let friendlyName: String
    
    let body: String?
}

protocol Transaction {
    var network: Network { get }
    var body: String { get }
    var type: Chain { get }
    
    func encode() -> String
}

protocol DecodedTransaction {
    var isStandard: Bool { get }
    var network: Network { get }
    var type: Chain { get }
    var amount: Double { get }
    var memo: String { get }
    var receiver: Address { get }
    var sender: Address { get }
    var extra: String? { get }
}

protocol SignedTransaction {
    var network: Network { get }
    var type: Chain { get }
    var body: String { get }
    var unsigned: Transaction { get }
    var signatures: [String] { get }
}

protocol CryptoWallet {
    var type: Chain { get }
    var addresses: [Address] { get }
    
    init(from seed: Data)
    
    func loaded(completion: @escaping (Address?) -> ())
    func decode(tx: Transaction) -> DecodedTransaction?
    func decode(tx: String) -> Transaction?
    func sign(tx: Transaction) -> SignedTransaction?
    func sign(tx: Transaction, address: Address) -> SignedTransaction?
}
