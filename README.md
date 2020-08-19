# Clarity-Hackathon-Submission
This is my submission for Blockstack's August 2020 Clarity Hackathon. 

## Features
This contract servers as a quiz answer verifier and distributer of funds. Ideally, this contract would work best for fill-in-the-blank quizzes with many possible answers. Users submit answers (strings) to the smart contract. The contract takes u50 STX from their account and checks if they answered correctly. If so, they are added to the winners map and get a payout at the end.

## Techniques
Originally I wanted to store the user principals in a list but lists have a maximum storage capacity of 1 MB, which might be used quickly since I am storing user principals. Therefore, I decided to use a map. However, Clarity does not allow for iteration over maps. So, I maintain hybrid list/map data structure. The keys of the map correspond to the ints in the list and the values in the map are the winner principals.  Therefore, when I need to distribute the funds, I iterate over the list and look up the values in the winner map. 
