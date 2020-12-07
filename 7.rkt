#lang racket
(define rev-bags (make-hash))
(define bags (make-hash))

(define (parse-line line)
  (define contains-reg #px"(\\d+) (\\D+) bags?")
  (define name-reg #px"(\\D+) bags contain.*")
  (letrec ([groups (regexp-match contains-reg line)]
           [name (rest (regexp-match name-reg line))])
    (if groups
        (append (parse-line (regexp-replace contains-reg line ""))
                (list (cons (string->number (first (rest groups)))
                            (last groups))))
        name)))

(define (process-line line)
  (letrec ([parsed (parse-line line)]
           [bag (first parsed)]
           [contains (rest parsed)])
    (map (lambda (item)
           (hash-set! bags bag contains)
           (hash-set! rev-bags (cdr item)
                      (append
                        (hash-ref rev-bags (cdr item) (list))
                        (list bag))))
         contains)))

(define (traverse-containers target)
    (let ([val (hash-ref rev-bags target #f)])
      (if val
          (remove-duplicates (append val (flatten (map traverse-containers val))))
          (list))))

(define (count-containees target)
  (let ([val (hash-ref bags target #f)])
    (if val
        (apply + 
               (map (lambda (p)
                        (+ (car p)
                           (* (car p) (count-containees (cdr p)))))
                  val))
        0)))

(for ([line (file->lines "7.in")])
  (process-line line))

(length (traverse-containers "shiny gold"))
(count-containees "shiny gold")
