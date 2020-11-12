# Clarity-Hackathon-Submission

## Use Cases
This contract serves as a quiz answer verifier and distributer of funds. Ideally, this contract would work best for fill-in-the-blank quizzes with many possible answers. I believe this contract can be used for follow-ups to educational podcast or YouTube videos. When the audience finishes educational content, they can be prompted with a quiz to test their knowledge and potentially win STX tokens!

## Structure
Users submit answers (strings) to the smart contract. The contract takes u50 STX from their account and checks if they answered correctly. If so, they are added to the winners map and receive a payout when a threshold is reached, otherwise, they will lose their funds, which become part of the jackpot held on the contract. 


## Techniques
Originally I wanted to store the user principals in a list but lists have a maximum storage capacity of 1 MB, which might be used up quickly. Therefore, I decided to use a map, which has no storage limit. However, Clarity does not allow for native iteration over maps. So, I maintain hybrid list/map data structure. The keys of the map correspond to the ints in the list and the values in the map are the winner principals. Therefore, when I need to distribute the funds, I iterate over the list and look up the values in the winner map. 
