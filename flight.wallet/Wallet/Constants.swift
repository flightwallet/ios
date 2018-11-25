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
    
    var curr_name: String {
        switch self {
        case .Bitcoin:  return "BTC"
        case .Ethereum: return "ETH"
        default:        return "crypto"
        }
    }
}

func debug(_ label: Any?, _ value: Any? = nil) {
    if value == nil {
        print(label ?? "nil")
    } else {
        print(label ?? "value", value as Any)
    }
}

protocol AbstractAddress {
    var isMainnet: Bool { get }
    var type: Chain { get }
    var body: String? { get }
}

struct Address: AbstractAddress {
    var isMainnet: Bool {
        return network == .Mainnet
    }
    
    let network: Network
    let type: Chain
    let path: String
    let friendlyName: String
    
    let body: String?
}

extension Address: Hashable {}

func ==(left: AbstractAddress, right: AbstractAddress) -> Bool {
    return left.isMainnet == right.isMainnet
        && left.type == right.type
        && left.body == right.body
}

func !=(left: AbstractAddress, right: AbstractAddress) -> Bool {
    return !(left == right)
}

protocol TransactionOutput {
    var address: AbstractAddress? { get }
    var amount: Double? { get }
}

protocol TransactionInput {
    var address: AbstractAddress? { get }
    var amount: Double? { get }
    var text: String? { get }
}

protocol Transaction {
    var network: Network { get }
    var body: String { get }
    var type: Chain { get }
    
    var sender: String? { get }
    var destination: String? { get }
    
    var total: Double? { get }
    var fee: Double? { get }
    
    var tx_inputs: [TransactionInput]? { get }
    var tx_outputs: [TransactionOutput]? { get }
    
    func estimateChange(ownerAddress: AbstractAddress) -> Double
    func estimateAmount(ownerAddress: AbstractAddress) -> Double
    
    func encode() -> String
    func decode(rawhex: String) -> Transaction
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

protocol SignedTransaction: Transaction {
    var network: Network { get }
    var type: Chain { get }
    var body: String { get }
    var unsigned: Transaction { get }
    var signatures: [String] { get }
}

protocol WalletUpdateInfo {
    init?(from json: String)
    var type: Chain { get }
    var forAddress: Address? { get }
}

protocol CryptoWallet {
    var type: Chain { get }
    var addresses: [Address] { get }
    
    init(from seed: Data)
    
    func loaded(completion: @escaping (Address?) -> ())
    func decode(tx: String) -> Transaction?
    func sign(tx: Transaction) -> SignedTransaction?
    func sign(tx: Transaction, address: Address) -> SignedTransaction?
    
    func sync(update: WalletUpdateInfo) -> Bool
    func buildTx(from address: Address?, to: AbstractAddress, value: Double) -> Transaction?
}
