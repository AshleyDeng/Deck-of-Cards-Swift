import Foundation
import XCTest

/// Defines the Rank enum for Card
enum Rank: Int {
  case Ace = 1
  case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
  case Jack, Queen, King
  
  static let allValues = [Ace, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King]
  
  func simpleDescription() -> String {
    switch self {
    case .Ace:
      return "ace"
    case .Jack:
      return "jack"
    case .Queen:
      return "queen"
    case .King:
      return "king"
    default:
      return String(self.rawValue)
    }
  }
}

/// Defines the Suit enum for Card
enum Suit {
  case Spades, Hearts, Diamonds, Clubs
  
  static let allValues = [Spades, Hearts, Diamonds, Clubs]
  
  func simpleDescription() -> String {
    switch self {
    case .Spades:
      return "spades"
    case .Hearts:
      return "hearts"
    case .Diamonds:
      return "diamonds"
    case .Clubs:
      return "clubs"
    }
  }
}

/// Defines the data structure for Card
struct Card {
  var rank: Rank
  var suit: Suit
  
  init(rank: Rank, suit: Suit) {
    self.rank = rank
    self.suit = suit
  }
  
  func simpleDescription() -> String {
    return "The \(rank.simpleDescription()) of \(suit.simpleDescription())"
  }
}

/// Representing a deck of cards with methods to manipulate it.
class DeckOfCards {
  
  /// Holds a deck of cards
  var deckOfCards: [Card]
  
  /// Constructor method for creating a deck of cards
  init() {
    self.deckOfCards = [Card]()
    
    for rank in Rank.allValues {
      for suit in Suit.allValues {
        self.deckOfCards.append(Card(rank: rank, suit: suit))
      }
    }
  }
  
  /// Deals one card from the current deck. Pops the last card from the deck.
  ///
  /// - Returns: The last card of the deck
  func dealOneCard() -> Card {
    return deckOfCards.removeLast()
  }
  
  /// Shuffles the deck into random order
  func shuffle() {
    var shuffled = [Card]()
    
    // Fisher-Yates shuffle algorithm
    for _ in 0 ..< deckOfCards.count {
      // Get a random that is within the length of the array
      let randomNumber = Int(arc4random_uniform(UInt32(deckOfCards.count)))
      
      // Remove a card and then put it into shuffled array
      shuffled.append(deckOfCards.remove(at: randomNumber))
    }
    
    deckOfCards = shuffled
  }
  
  /// Pops the last card in deck until no card is left
  func dealAllCards() {
    while deckOfCards.count > 0 {
      print("Dealing \(dealOneCard().simpleDescription())")
    }
  }
}

/// Simple manual test
let deck = DeckOfCards()
deck.shuffle()
print(deck.deckOfCards.count)

var card = deck.dealOneCard()
print(card.simpleDescription())
print(deck.deckOfCards.count)

card = deck.dealOneCard()
print(card.simpleDescription())
print(deck.deckOfCards.count)

deck.dealAllCards()




// MARK: Unit tests
class RankTests: XCTestCase {
  var rank: Rank!
  
  func testRankDescription() {
    // Given
    rank = Rank.Ace
    
    // When and then
    XCTAssertEqual("ace", rank.simpleDescription())
    
    // Given
    rank = Rank.Four
    
    // When and then
    XCTAssertEqual("4", rank.simpleDescription())
    
    // Given
    rank = Rank.King
    
    // When and then
    XCTAssertEqual("king", rank.simpleDescription())
    XCTAssertEqual(13, Rank.allValues.count)
  }
}

RankTests.defaultTestSuite.run()

class SuitTests: XCTestCase {
  var suit: Suit!
  
  func testSuitDescription() {
    // Given
    suit = Suit.Clubs
    
    // When and then
    XCTAssertEqual("clubs", suit.simpleDescription())
    XCTAssertEqual(4, Suit.allValues.count)
  }
}

SuitTests.defaultTestSuite.run()

class CardTests: XCTestCase {
  var card: Card!
  
  func testCardConstrutorAndDescription() {
    // Given
    card = Card(rank: Rank.Ace, suit: Suit.Spades)
    
    // When and then
    XCTAssertEqual("The ace of spades", card.simpleDescription())
  }
}

CardTests.defaultTestSuite.run()

class DeckOfCardsTests: XCTestCase {
  var deck: DeckOfCards!

  override func setUp() {
    super.setUp()
    // Given
    deck = DeckOfCards()
  }

  func testDeckCreated() {
    // When and Then
    XCTAssertNotNil(deck)
    XCTAssertEqual(52, deck.deckOfCards.count)
  }
  
  func testDealOneCard() {
    // When
    var card = deck.dealOneCard()
    
    // Then
    XCTAssertEqual(51, deck.deckOfCards.count)
    XCTAssertEqual("The king of clubs", card.simpleDescription())
    
    // When
    card = deck.dealOneCard()
    
    // Then
    XCTAssertEqual(50, deck.deckOfCards.count)
    XCTAssertEqual("The king of diamonds", card.simpleDescription())
  }
  
  
  /// Make sure after shuffle, the number of cards should be the same
  func testShuffle() {
    // When
    deck.shuffle()
    
    // Then
    XCTAssertEqual(52, deck.deckOfCards.count)
    
    // Given
    _ = deck.dealOneCard()
    _ = deck.dealOneCard()
    XCTAssertEqual(50, deck.deckOfCards.count)
    
    // When
    deck.shuffle()
    
    // Then
    XCTAssertEqual(50, deck.deckOfCards.count)
  }
  
  /// Make sure after dealing all cards, nothing is left
  func testDealAllCards() {
    // When
    deck.dealAllCards()
    
    // Then
    XCTAssertEqual(0, deck.deckOfCards.count)
  }
  
  /// Make sure after dealing all cards, nothing is left
  func testDealAllCardsWhenDeckIsNotFull() {
    // Given
    _ = deck.dealOneCard()
    XCTAssertEqual(51, deck.deckOfCards.count)
    
    // When
    deck.dealAllCards()
    
    // Then
    XCTAssertEqual(0, deck.deckOfCards.count)
  }
}

DeckOfCardsTests.defaultTestSuite.run()
