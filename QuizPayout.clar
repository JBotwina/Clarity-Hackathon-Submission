;; secret answer. On deployment, we would only save the hash so that the true answer is not observed.
(define-constant answer (hash160 "blockstack"))
;;test limit for number of winners
(define-constant winner-limit 3)

;;counter used to keep track of current number of winners
(define-data-var counter int 0)

;; payout to be calculated as game is played
(define-data-var payout int 0)

;; map to hold principals of the winners
(define-map winners 
 ((idx int)) 
 ((user principal)))

;;list to hold ids of the winners so that we can iterate over winner map at payout
(define-data-var tracker (list 3 int) (list))


;;send stx to the contract. we use u50 stx as a test number
(define-private (transfer-tokens (participant principal)) 
 (as-contract 
  (stx-transfer? u50 participant  tx-sender)))

;;at payout, distribute funds to the winners

(define-private (distribute-funds (winner int)) 
  (as-contract 
    (stx-transfer? 
      (to-uint (var-get payout)) 
      tx-sender 
      (get user (unwrap! (map-get? winners {idx: winner}) (err u0))))))

;; 1) calculates the payout 
;; 2) uses map to iterate over the winners and distributes the payouts

(define-private (begin-distribution)  
  (begin
    (var-set payout 
      (/ (to-int (as-contract (stx-get-balance tx-sender)))  
        (to-int (len (var-get tracker))))) 
    (map distribute-funds (var-get tracker))
    (ok "Distributed funds")))

;; add a winner to the winner map and list. begins distribution 
;; process if the counter equals the winner limit

(define-private (add-winner (winner principal))
  (begin
    (map-set winners {idx: (var-get counter)} {user: winner}) 
    (var-set tracker
            (unwrap-panic 
            (as-max-len? 
              (append (var-get tracker) 
                      (var-get counter))
              u3)))
    (if (is-eq (var-get counter) winner-limit) 
      (begin-distribution) 
      (ok "Continue Game"))))

;;MAIN FUNCTION

(define-public (check-answer (attempt (buff 100)))
  (if (>= (var-get counter) winner-limit)
    (ok "you are too late") 
    (begin 
      (transfer-tokens tx-sender) 
      (var-set counter (+ (var-get counter) 1))
      (if (is-eq (hash160 attempt) answer)
        (add-winner tx-sender) 
        (ok "You Lose")))))
