cd "C:\Users\rpseely\OneDrive - Syracuse University\Documents\GitHub\exercises\course-project-nepobabies"

use "GSSclean_noRDs" 
 

keep year rincome age dateintv educ paeduc maeduc jobinc jobsec jobpay ///
jobkeep jobhonor jobinter fndjob2 thisjob7 wrkwell paind16 paind10 paind80 ///
maind80 maind10 indus10 major1 major2 voedcol voedncol colmajr1 colmajr2 ///
joblose yearsjob covemply race parborn granborn wealth opwlth income72 ///
income77 income82 income86 income91 income98 income06 income16 coninc realinc ///
povline incdef wlthpov progtax oprich inequal3 taxrich taxshare contrich ///
class class1 hrs1 hrs2 jobhour hrswork workhr sethours sex intltest ///
skiltest wojobyrs occmobil lastslf gender1 gender2 gender3 gender4 gender5 ///
gender6 gender7 gender8 gender9 gender10 gender11 gender12 gender13 gender14 ///
gdjobsec thisjob2



 
 **the next few lines are for getting an idea of those variables look like 
tab dateintv
tab educ
tab fndjob2

**this gives us important information on the number of observation and descriptive statistics of important variables
summarize fndjob2 educ dateintv major1 paeduc maeduc industry indus80 indus07 indus10 paind10 paind80 paind16 maind10 maind80 indfirst

**this examines the relationship between education and finding a job through a relative
graph box educ, over (fndjob2)

save "GSSclean_noRDs.dta" , replace

** This prevents false positives from occurring for the nepobaby, panepobaby, and manepobaby variables.
replace indus10 = 1 if missing(indus10)

**Creating dummy variable for nepobaby = 1 if respondent is in the same industry as their mother or father, 0 otherwise
gen nepobaby = ((indus10 == paind10)|(indus10 == maind10))
** Create variable for being in the same industry as ONLY a respondent's father. (same false positives as nepobaby)
gen panepobaby = (indus10 == paind10)
** Create variable for being in the same industry as ONLY a respondent's mother. (same false positives as nepobaby)
gen manepobaby = (indus10 == maind10)


keep year rincome age dateintv educ paeduc maeduc jobinc jobsec jobpay ///
jobkeep jobhonor jobinter fndjob2 thisjob7 wrkwell paind16 paind10 paind80 ///
maind80 maind10 indus10 major1 major2 voedcol voedncol colmajr1 colmajr2 ///
joblose yearsjob covemply race parborn granborn wealth opwlth income72 ///
income77 income82 income86 income91 income98 income06 income16 coninc realinc ///
povline incdef wlthpov progtax oprich inequal3 taxrich taxshare contrich ///
class class1 hrs1 hrs2 jobhour hrswork workhr sethours sex intltest ///
skiltest wojobyrs occmobil lastslf gender1 gender2 gender3 gender4 gender5 ///
gender6 gender7 gender8 gender9 gender10 gender11 gender12 gender13 gender14 ///
gdjobsec thisjob2

**Getting rid of missing data
drop if year < 1975
drop if missing(dateintv)

* Convert dateintv to a string for easier manipulation
gen dateintv_str = string(dateintv)

* Extract dayintv (last two digits)
gen dayintv = real(substr(dateintv_str, -2, .))

* Extract monthintv based on the length of dateintv
gen monthintv = .
replace monthintv = real(substr(dateintv_str, 1, 1)) if length(dateintv_str) == 3
replace monthintv = real(substr(dateintv_str, 1, 2)) if length(dateintv_str) == 4

* Display the results
browse dateintv dateintv_str dayintv monthintv year

* Rename year variable for clarity
rename year yearintv

** This created a variable for the year and month a respondent was interviewed!
** It does so in the format of a Stata date, where Jan. 1960 is considered 1 and every month's code after that = (months after Jan. 1960)
gen ymintdate = ym(yearintv, monthintv)

** Creates a variable for the month and year a respondent was hired (assuming they were hired exactly the number of years ago they reported) which leaves us with 9,256 variables/.
gen ymhiredate = ymintdate - (yearsjob * 12)

** We can only perform analysis for the respondents who answered the `yearsjob` question.
drop if missing(yearsjob)

** Run the do-file that inputs unemployment rates by month.
do 

*** Manual input of unemployment rates by month
*** We must actually create the unemployment rates variable. It worked for me when I created the variable in the data editor but I did not save that. We must figure out how to do that. I imagine it will look something like...
gen unemployrate = .

*1987
*January
replace unemployrate = 6.6 if ymhiredate == 324
*Febrary
replace unemployrate = 6.6 if ymhiredate == 325
*March
replace unemployrate = 6.6 if ymhiredate == 326
*April
replace unemployrate = 6.3 if ymhiredate == 327
*May
replace unemployrate = 6.3 if ymhiredate == 328
*June
replace unemployrate = 6.2 if ymhiredate == 329
*July 
replace unemployrate = 6.1 if ymhiredate == 330
*August 
replace unemployrate = 6.0 if ymhiredate == 331
*September
replace unemployrate = 5.9 if ymhiredate == 332
*October
replace unemployrate = 6.0 if ymhiredate == 333
*November
replace unemployrate = 5.8 if ymhiredate == 334
*December 
replace unemployrate = 5.7 if ymhiredate == 335

*1988 
*January
replace unemployrate = 5.7 if ymhiredate == 336
*February
replace unemployrate = 5.7 if ymhiredate == 337
*March
replace unemployrate = 5.7 if ymhiredate == 338
*April
replace unemployrate = 5.4 if ymhiredate == 339
*May
replace unemployrate = 5.6 if ymhiredate == 340
*June
replace unemployrate = 5.4 if ymhiredate == 341
*July 
replace unemployrate = 5.4 if ymhiredate == 342
*August
replace unemployrate = 5.6 if ymhiredate == 343
*September
replace unemployrate = 5.4 if ymhiredate == 344
*October
replace unemployrate = 5.4 if ymhiredate == 345
*November 
replace unemployrate = 5.3 if ymhiredate == 346
*December 
replace unemployrate = 5.3 if ymhiredate == 347

*1989
*January
replace unemployrate = 5.4 if ymhiredate == 348
*February
replace unemployrate = 5.2 if ymhiredate == 349
*March
replace unemployrate = 5.0 if ymhiredate == 350
*April
replace unemployrate = 5.2 if ymhiredate == 351
*May
replace unemployrate = 5.2 if ymhiredate == 352
*June
replace unemployrate = 5.3 if ymhiredate == 353
*July
replace unemployrate = 5.2 if ymhiredate == 354
*August
replace unemployrate = 5.2 if ymhiredate == 355
*September
replace unemployrate = 5.3 if ymhiredate == 356
*October
replace unemployrate = 5.3 if ymhiredate == 357
*November 
replace unemployrate = 5.4 if ymhiredate == 358
*December
replace unemployrate = 5.4 if ymhiredate == 359

*1990
*January
replace unemployrate = 5.4 if ymhiredate == 360
*February
replace unemployrate = 5.3 if ymhiredate == 361
*March
replace unemployrate = 5.2 if ymhiredate == 362
*April
replace unemployrate = 5.4 if ymhiredate == 363
*May
replace unemployrate = 5.4 if ymhiredate == 364
*June
replace unemployrate = 5.2 if ymhiredate == 365
*July
replace unemployrate = 5.5 if ymhiredate == 366
*August
replace unemployrate = 5.7 if ymhiredate == 367
*September
replace unemployrate = 5.9 if ymhiredate == 368
*October
replace unemployrate = 5.9 if ymhiredate == 369
*November
replace unemployrate = 6.2 if ymhiredate == 370
*December 
replace unemployrate = 6.3 if ymhiredate == 371

*1991
*January
replace unemployrate = 6.4 if ymhiredate == 372
*February
replace unemployrate = 6.6 if ymhiredate == 373
*March
replace unemployrate = 6.8 if ymhiredate == 374
*April
replace unemployrate = 6.7 if ymhiredate == 375
*May
replace unemployrate = 6.9 if ymhiredate == 376
*June
replace unemployrate = 6.9 if ymhiredate == 377
*July
replace unemployrate = 6.8 if ymhiredate == 378
*August
replace unemployrate = 6.9 if ymhiredate == 379
*September
replace unemployrate = 6.9 if ymhiredate == 380
*October
replace unemployrate = 7.0 if ymhiredate == 381
*November 
replace unemployrate = 7.0 if ymhiredate == 382
*December 
replace unemployrate = 7.3 if ymhiredate == 383

*1992
*January
replace unemployrate = 7.3 if ymhiredate == 384
*February
replace unemployrate = 7.4 if ymhiredate == 385
*March
replace unemployrate = 7.4 if ymhiredate == 386
*April
replace unemployrate = 7.4 if ymhiredate == 387
*May
replace unemployrate = 7.6 if ymhiredate == 388
*June
replace unemployrate = 7.8 if ymhiredate == 389
*July
replace unemployrate = 7.7 if ymhiredate == 390
*August
replace unemployrate = 7.6 if ymhiredate == 391
*September
replace unemployrate = 7.6 if ymhiredate == 392
*October
replace unemployrate = 7.3 if ymhiredate == 393
*November
replace unemployrate = 7.4 if ymhiredate == 394
*December 
replace unemployrate = 7.4 if ymhiredate == 395

*1993
*January
replace unemployrate = 7.3 if ymhiredate == 396
*February
replace unemployrate = 7.1 if ymhiredate == 397
*March
replace unemployrate = 7.0 if ymhiredate == 398
*April
replace unemployrate = 7.1 if ymhiredate == 399
*May
replace unemployrate = 7.1 if ymhiredate == 400
*June
replace unemployrate = 7.0 if ymhiredate == 401
*July
replace unemployrate = 6.9 if ymhiredate == 402
*August
replace unemployrate = 6.8 if ymhiredate == 403
*September
replace unemployrate = 6.7 if ymhiredate == 404
*October
replace unemployrate = 6.8 if ymhiredate == 405
*November
replace unemployrate = 6.6 if ymhiredate == 406
*December 
replace unemployrate = 6.5 if ymhiredate == 407

*1994
*January
replace unemployrate = 6.6 if ymhiredate == 408
*February
replace unemployrate = 6.6 if ymhiredate == 409
*March
replace unemployrate = 6.5 if ymhiredate == 410
*April
replace unemployrate = 6.4 if ymhiredate == 411
*May
replace unemployrate = 6.1 if ymhiredate == 412
*June
replace unemployrate = 6.1 if ymhiredate == 413
*July
replace unemployrate = 6.1 if ymhiredate == 414
*August
replace unemployrate = 6.0 if ymhiredate == 415
*September
replace unemployrate = 5.9 if ymhiredate == 416
*October
replace unemployrate = 5.8 if ymhiredate == 417
*November
replace unemployrate = 5.6 if ymhiredate == 418
*December 
replace unemployrate = 5.5 if ymhiredate == 419

*1995
*January
replace unemployrate = 5.6 if ymhiredate == 420
*February
replace unemployrate = 5.4 if ymhiredate == 421
*March
replace unemployrate = 5.4 if ymhiredate == 422
*April
replace unemployrate = 5.8 if ymhiredate == 423
*May
replace unemployrate = 5.6 if ymhiredate == 424
*June
replace unemployrate = 5.6 if ymhiredate == 425
*July
replace unemployrate = 5.7 if ymhiredate == 426
*August
replace unemployrate = 5.7 if ymhiredate == 427
*September
replace unemployrate = 5.6 if ymhiredate == 428
*October
replace unemployrate = 5.5 if ymhiredate == 429
*November
replace unemployrate = 5.6 if ymhiredate == 430
*December
replace unemployrate = 5.6 if ymhiredate == 431

*1996
*January
replace unemployrate = 5.6 if ymhiredate == 432
*February
replace unemployrate = 5.5 if ymhiredate == 433
*March
replace unemployrate = 5.5 if ymhiredate == 434
*April
replace unemployrate = 5.6 if ymhiredate == 435
*May
replace unemployrate = 5.6 if ymhiredate == 436
*June
replace unemployrate = 5.3 if ymhiredate == 437
*July
replace unemployrate = 5.4 if ymhiredate == 438
*August
replace unemployrate = 5.1 if ymhiredate == 439
*September
replace unemployrate = 5.2 if ymhiredate == 440
*October
replace unemployrate = 5.2 if ymhiredate == 441
*November
replace unemployrate = 5.4 if ymhiredate == 442
*December 
replace unemployrate = 5.4 if ymhiredate == 443

*1997
*January
replace unemployrate = 5.3 if ymhiredate == 444
*February
replace unemployrate = 5.2 if ymhiredate == 445
*March
replace unemployrate = 5.2 if ymhiredate == 446
*April
replace unemployrate = 5.1 if ymhiredate == 447
*May
replace unemployrate = 4.9 if ymhiredate == 448
*June
replace unemployrate = 5.0 if ymhiredate == 449
*July
replace unemployrate = 4.9 if ymhiredate == 450
*August
replace unemployrate = 4.8 if ymhiredate == 451
*September
replace unemployrate = 4.9 if ymhiredate == 452
*October
replace unemployrate = 4.7 if ymhiredate == 453
*November
replace unemployrate = 4.6 if ymhiredate == 454
*December
replace unemployrate = 4.7 if ymhiredate == 455

*1998
*January
replace unemployrate = 4.6 if ymhiredate == 456
*February
replace unemployrate = 4.6 if ymhiredate == 457
*March
replace unemployrate = 4.7 if ymhiredate == 458
*April
replace unemployrate = 4.3 if ymhiredate == 459
*May
replace unemployrate = 4.4 if ymhiredate == 460
*June
replace unemployrate = 4.5 if ymhiredate == 461
*July
replace unemployrate = 4.5 if ymhiredate == 462
*August
replace unemployrate = 4.5 if ymhiredate == 463
*September
replace unemployrate = 4.6 if ymhiredate == 464
*October
replace unemployrate = 4.5 if ymhiredate == 465
*November
replace unemployrate = 4.4 if ymhiredate == 466
*December
replace unemployrate = 4.4 if ymhiredate == 467

*1999
*January
replace unemployrate = 4.3 if ymhiredate == 468
*February
replace unemployrate = 4.4 if ymhiredate == 469
*March
replace unemployrate = 4.2 if ymhiredate == 470
*April
replace unemployrate = 4.3 if ymhiredate == 471
*May
replace unemployrate = 4.2 if ymhiredate == 472
*June
replace unemployrate = 4.3 if ymhiredate == 473
*July
replace unemployrate = 4.3 if ymhiredate == 474
*August
replace unemployrate = 4.2 if ymhiredate == 475
*September
replace unemployrate = 4.2 if ymhiredate == 476
*October
replace unemployrate = 4.1 if ymhiredate == 477
*November
replace unemployrate = 4.1 if ymhiredate == 478
*December
replace unemployrate = 4.0 if ymhiredate == 479

*2000
*January
replace unemployrate = 4.0 if ymhiredate == 480
*February
replace unemployrate = 4.1 if ymhiredate == 481
*March
replace unemployrate = 4.0 if ymhiredate == 482
*April
replace unemployrate = 3.8 if ymhiredate == 483
*May
replace unemployrate = 4.0 if ymhiredate == 484
*June
replace unemployrate = 4.0 if ymhiredate == 485
*July
replace unemployrate = 4.0 if ymhiredate == 486
*August
replace unemployrate = 4.1 if ymhiredate == 487
*September 
replace unemployrate = 3.9 if ymhiredate == 488
*October
replace unemployrate = 3.9 if ymhiredate == 489
*November
replace unemployrate = 3.9 if ymhiredate == 490
*December 
replace unemployrate = 3.9 if ymhiredate == 491

*2001
*January
replace unemployrate = 4.2 if ymhiredate == 492
*February
replace unemployrate = 4.2 if ymhiredate == 493
*March
replace unemployrate = 4.3 if ymhiredate == 494
*April
replace unemployrate = 4.4 if ymhiredate == 495
*May
replace unemployrate = 4.3 if ymhiredate == 496
*June
replace unemployrate = 4.5 if ymhiredate == 497
*July
replace unemployrate = 4.6 if ymhiredate == 498
*August
replace unemployrate = 4.9 if ymhiredate == 499
*September
replace unemployrate = 5.0 if ymhiredate == 500
*October
replace unemployrate = 5.3 if ymhiredate == 501
*November
replace unemployrate = 5.5 if ymhiredate == 502
*December
replace unemployrate = 5.7 if ymhiredate == 503

*2002
*January
replace unemployrate = 5.7 if ymhiredate == 504
*February
replace unemployrate = 5.7 if ymhiredate == 505
*March
replace unemployrate = 5.7 if ymhiredate == 506
*April
replace unemployrate = 5.9 if ymhiredate == 507
*May
replace unemployrate = 5.8 if ymhiredate == 508
*June 
replace unemployrate = 5.8 if ymhiredate == 509
*July
replace unemployrate = 5.8 if ymhiredate == 510
*August
replace unemployrate = 5.7 if ymhiredate == 511
*September
replace unemployrate = 5.7 if ymhiredate == 512
*October
replace unemployrate = 5.7 if ymhiredate == 513
*November
replace unemployrate = 5.9 if ymhiredate == 514
*December 
replace unemployrate = 6.0 if ymhiredate == 515

*2003
*January
replace unemployrate = 5.8 if ymhiredate == 516
*February
replace unemployrate = 5.9 if ymhiredate == 517
*March
replace unemployrate = 5.9 if ymhiredate == 518
*April
replace unemployrate = 6.0 if ymhiredate == 519
*May
replace unemployrate = 6.1 if ymhiredate == 520
*June
replace unemployrate = 6.3 if ymhiredate == 521
*July
replace unemployrate = 6.2 if ymhiredate == 522
*August
replace unemployrate = 6.1 if ymhiredate == 523
*September
replace unemployrate = 6.1 if ymhiredate == 524
*October
replace unemployrate = 6.0 if ymhiredate == 525
*November
replace unemployrate = 5.8 if ymhiredate == 526
*December
replace unemployrate = 5.7 if ymhiredate == 527

*2004
*January
replace unemployrate = 5.7 if ymhiredate == 528
*February
replace unemployrate = 5.6 if ymhiredate == 529
*March
replace unemployrate = 5.8 if ymhiredate == 530
*April
replace unemployrate = 5.6 if ymhiredate == 531
*May
replace unemployrate = 5.6 if ymhiredate == 532
*June
replace unemployrate = 5.6 if ymhiredate == 533
*July
replace unemployrate = 5.5 if ymhiredate == 534
*August
replace unemployrate = 5.4 if ymhiredate == 535
*September
replace unemployrate = 5.4 if ymhiredate == 536
*October
replace unemployrate = 5.5 if ymhiredate == 537
*November
replace unemployrate = 5.4 if ymhiredate == 538
*December
replace unemployrate = 5.4 if ymhiredate == 539

*2005
*January
replace unemployrate = 5.3 if ymhiredate == 540
*February 
replace unemployrate = 5.4 if ymhiredate == 541
*March 
replace unemployrate = 5.2 if ymhiredate == 542
*April 
replace unemployrate = 5.2 if ymhiredate == 543
*May 
replace unemployrate = 5.1 if ymhiredate == 544
*June 
replace unemployrate = 5.0 if ymhiredate == 545
*July 
replace unemployrate = 5.0 if ymhiredate == 546
*August 
replace unemployrate = 4.9 if ymhiredate == 547
*September 
replace unemployrate = 5.0 if ymhiredate == 548
*October 
replace unemployrate = 5.0 if ymhiredate == 549
*November 
replace unemployrate = 5.0 if ymhiredate == 550
*December 
replace unemployrate = 4.9 if ymhiredate == 551

*2006
*January
replace unemployrate = 4.7 if ymhiredate == 552
*February 
replace unemployrate = 4.8 if ymhiredate == 553
*March 
replace unemployrate = 4.7 if ymhiredate == 554
*April 
replace unemployrate = 4.7 if ymhiredate == 555
*May 
replace unemployrate = 4.6 if ymhiredate == 556
*June 
replace unemployrate = 4.6 if ymhiredate == 557
*July 
replace unemployrate = 4.7 if ymhiredate == 558
*August 
replace unemployrate = 4.7 if ymhiredate == 559
*September 
replace unemployrate = 4.5 if ymhiredate == 560
*October 
replace unemployrate = 4.4 if ymhiredate == 561
*November 
replace unemployrate = 4.5 if ymhiredate == 562
*December 
replace unemployrate = 4.4 if ymhiredate == 563

*2007
*January
replace unemployrate = 4.6 if ymhiredate == 564
*February 
replace unemployrate = 4.5 if ymhiredate == 565
*March 
replace unemployrate = 4.4 if ymhiredate == 566
*April 
replace unemployrate = 4.5 if ymhiredate == 567
*May 
replace unemployrate = 4.4 if ymhiredate == 568
*June 
replace unemployrate = 4.6 if ymhiredate == 569
*July 
replace unemployrate = 4.7 if ymhiredate == 570
*August 
replace unemployrate = 4.6 if ymhiredate == 571
*September 
replace unemployrate = 4.7 if ymhiredate == 572
*October 
replace unemployrate = 4.7 if ymhiredate == 573
*November 
replace unemployrate = 4.7 if ymhiredate == 574
*December 
replace unemployrate = 5.0 if ymhiredate == 575

*2008
*January
replace unemployrate = 5.0 if ymhiredate == 576
*February 
replace unemployrate = 4.9 if ymhiredate == 577
*March 
replace unemployrate = 5.1 if ymhiredate == 578
*April 
replace unemployrate = 5.0 if ymhiredate == 579
*May 
replace unemployrate = 5.4 if ymhiredate == 580
*June 
replace unemployrate = 5.6 if ymhiredate == 581
*July 
replace unemployrate = 5.8 if ymhiredate == 582
*August 
replace unemployrate = 6.1 if ymhiredate == 583
*September 
replace unemployrate = 6.1 if ymhiredate == 584
*October 
replace unemployrate = 6.5 if ymhiredate == 585
*November 
replace unemployrate = 6.8 if ymhiredate == 586
*December 
replace unemployrate = 7.3 if ymhiredate == 587

*2009
*January
replace unemployrate = 7.8 if ymhiredate == 588
*February 
replace unemployrate = 8.3 if ymhiredate == 589
*March 
replace unemployrate = 8.7 if ymhiredate == 590
*April 
replace unemployrate = 9.0 if ymhiredate == 591
*May 
replace unemployrate = 9.4 if ymhiredate == 592
*June 
replace unemployrate = 9.5 if ymhiredate == 593
*July 
replace unemployrate = 9.5 if ymhiredate == 594
*August 
replace unemployrate = 9.6 if ymhiredate == 595
*September 
replace unemployrate = 9.8 if ymhiredate == 596
*October 
replace unemployrate = 10.0 if ymhiredate == 597
*November 
replace unemployrate = 9.9 if ymhiredate == 598
*December 
replace unemployrate = 9.9 if ymhiredate == 599

*2010
*January
replace unemployrate = 9.8 if ymhiredate == 600
*February 
replace unemployrate = 9.8 if ymhiredate == 601
*March 
replace unemployrate = 9.9 if ymhiredate == 602
*April 
replace unemployrate = 9.9 if ymhiredate == 603
*May 
replace unemployrate = 9.6 if ymhiredate == 604
*June 
replace unemployrate = 9.4 if ymhiredate == 605
*July 
replace unemployrate = 9.4 if ymhiredate == 606
*August 
replace unemployrate = 9.5 if ymhiredate == 607
*September 
replace unemployrate = 9.5 if ymhiredate == 608
*October 
replace unemployrate = 9.4 if ymhiredate == 609
*November 
replace unemployrate = 9.8 if ymhiredate == 610
*December 
replace unemployrate = 9.3 if ymhiredate == 611

*2011
*January
replace unemployrate = 9.1 if ymhiredate == 612
*February 
replace unemployrate = 9.0 if ymhiredate == 613
*March 
replace unemployrate = 9.0 if ymhiredate == 614
*April 
replace unemployrate = 9.1 if ymhiredate == 615
*May
replace unemployrate = 9.0 if ymhiredate == 616
*June 
replace unemployrate = 9.1 if ymhiredate == 617
*July 
replace unemployrate = 9.0 if ymhiredate == 618
*August 
replace unemployrate = 9.0 if ymhiredate == 619
*September 
replace unemployrate = 9.0 if ymhiredate == 620
*October 
replace unemployrate = 8.8 if ymhiredate == 621
*November 
replace unemployrate = 8.6 if ymhiredate == 622
*December 
replace unemployrate = 8.5 if ymhiredate == 623
*2012
*January
replace unemployrate = 8.3 if ymhiredate == 624
*February 
replace unemployrate = 8.3 if ymhiredate == 625
*March 
replace unemployrate = 8.2 if ymhiredate == 626
*April 
replace unemployrate = 8.2 if ymhiredate == 627
*May
replace unemployrate = 8.2 if ymhiredate == 628
*June 
replace unemployrate = 8.2 if ymhiredate == 629
*July 
replace unemployrate = 8.2 if ymhiredate == 630
*August 
replace unemployrate = 8.1 if ymhiredate == 631
*September 
replace unemployrate = 7.8 if ymhiredate == 632
*October 
replace unemployrate = 7.8 if ymhiredate == 633
*November 
replace unemployrate = 7.7 if ymhiredate == 634
*December 
replace unemployrate = 7.9 if ymhiredate == 635

*2013
*January
replace unemployrate = 8.0 if ymhiredate == 636
*February 
replace unemployrate = 7.7 if ymhiredate == 637
*March 
replace unemployrate = 7.5 if ymhiredate == 638
*April 
replace unemployrate = 7.6 if ymhiredate == 639
*May
replace unemployrate = 7.5 if ymhiredate == 640
*June 
replace unemployrate = 7.5 if ymhiredate == 641
*July 
replace unemployrate = 7.3 if ymhiredate == 642
*August 
replace unemployrate = 7.2 if ymhiredate == 643
*September 
replace unemployrate = 7.2 if ymhiredate == 644
*October 
replace unemployrate = 7.2 if ymhiredate == 645
*November 
replace unemployrate = 6.9 if ymhiredate == 646
*December 
replace unemployrate = 6.7 if ymhiredate == 647

*2014
*January
replace unemployrate = 6.6 if ymhiredate == 648
*February 
replace unemployrate = 6.7 if ymhiredate == 649
*March 
replace unemployrate = 6.7 if ymhiredate == 650
*April 
replace unemployrate = 6.2 if ymhiredate == 651
*May
replace unemployrate = 6.3 if ymhiredate == 652
*June 
replace unemployrate = 6.1 if ymhiredate == 653
*July 
replace unemployrate = 6.2 if ymhiredate == 654
*August 
replace unemployrate = 6.1 if ymhiredate == 655
*September 
replace unemployrate = 5.9 if ymhiredate == 656
*October 
replace unemployrate = 5.7 if ymhiredate == 657
*November 
replace unemployrate = 5.8 if ymhiredate == 658
*December 
replace unemployrate = 5.6 if ymhiredate == 659

*2015
*January
replace unemployrate = 5.7 if ymhiredate == 660
*February 
replace unemployrate = 5.5 if ymhiredate == 661
*March 
replace unemployrate = 5.4 if ymhiredate == 662
*April 
replace unemployrate = 5.4 if ymhiredate == 663
*May
replace unemployrate = 5.6 if ymhiredate == 664
*June 
replace unemployrate = 5.3 if ymhiredate == 665
*July 
replace unemployrate = 5.2 if ymhiredate == 666
*August 
replace unemployrate = 5.1 if ymhiredate == 667
*September
replace unemployrate = 5.0 if ymhiredate == 668
*October 
replace unemployrate = 5.0 if ymhiredate == 669
*November 
replace unemployrate = 5.1 if ymhiredate == 670
*December 
replace unemployrate = 5.0 if ymhiredate == 671

*2016
*January
replace unemployrate = 4.8 if ymhiredate == 672
*February 
replace unemployrate = 4.9 if ymhiredate == 673
*March 
replace unemployrate = 5.0 if ymhiredate == 674
*April 
replace unemployrate = 5.1 if ymhiredate == 675
*May
replace unemployrate = 4.8 if ymhiredate == 676
*June 
replace unemployrate = 4.9 if ymhiredate == 677
*July 
replace unemployrate = 4.8 if ymhiredate == 678
*August 
replace unemployrate = 4.9 if ymhiredate == 679
*September
replace unemployrate = 5.0 if ymhiredate == 680
*October 
replace unemployrate = 4.9 if ymhiredate == 681
*November 
replace unemployrate = 4.7 if ymhiredate == 682
*December 
replace unemployrate = 4.7 if ymhiredate == 683

*2017
*January
replace unemployrate = 4.7 if ymhiredate == 684
*February 
replace unemployrate = 4.6 if ymhiredate == 685
*March 
replace unemployrate = 4.4 if ymhiredate == 686
*April 
replace unemployrate = 4.4 if ymhiredate == 687
*May
replace unemployrate = 4.4 if ymhiredate == 688
*June 
replace unemployrate = 4.3 if ymhiredate == 689
*July 
replace unemployrate = 4.3 if ymhiredate == 690
*August 
replace unemployrate = 4.4 if ymhiredate == 691
*September
replace unemployrate = 4.3 if ymhiredate == 692
*October 
replace unemployrate = 4.2 if ymhiredate == 693
*November 
replace unemployrate = 4.2 if ymhiredate == 694
*December 
replace unemployrate = 4.1 if ymhiredate == 695

*2018
*January
replace unemployrate = 4.7 if ymhiredate == 696
*February 
replace unemployrate = 4.6 if ymhiredate == 697
*March 
replace unemployrate = 4.4 if ymhiredate == 698
*April 
replace unemployrate = 4.4 if ymhiredate == 699
*May
replace unemployrate = 4.4 if ymhiredate == 700
*June 
replace unemployrate = 4.3 if ymhiredate == 701
*July 
replace unemployrate = 4.3 if ymhiredate == 702
*August 
replace unemployrate = 4.4 if ymhiredate == 703
*September
replace unemployrate = 4.3 if ymhiredate == 704
*October 
replace unemployrate = 4.2 if ymhiredate == 705
*November 
replace unemployrate = 4.2 if ymhiredate == 706
*December 
replace unemployrate = 4.1 if ymhiredate == 707

*2019
*January
replace unemployrate = 4.0 if ymhiredate == 708
*February 
replace unemployrate = 3.8 if ymhiredate == 709
*March 
replace unemployrate = 3.8 if ymhiredate == 710
*April 
replace unemployrate = 3.6 if ymhiredate == 711
*May
replace unemployrate = 3.7 if ymhiredate == 712
*June 
replace unemployrate = 3.6 if ymhiredate == 713
*July 
replace unemployrate = 3.7 if ymhiredate == 714
*August 
replace unemployrate = 3.7 if ymhiredate == 715
*September
replace unemployrate = 3.5 if ymhiredate == 716
*October
replace unemployrate = 3.6 if ymhiredate == 717
*November 
replace unemployrate = 3.6 if ymhiredate == 718
*December 
replace unemployrate = 3.6 if ymhiredate == 719

*2020
*January
replace unemployrate = 3.5 if ymhiredate == 720
*February 
replace unemployrate = 3.5 if ymhiredate == 721
*March 
replace unemployrate = 4.4 if ymhiredate == 722
*April 
replace unemployrate = 14.7 if ymhiredate == 723
*May
replace unemployrate = 13.2 if ymhiredate == 724
*June 
replace unemployrate = 11.0 if ymhiredate == 725
*July 
replace unemployrate = 10.2 if ymhiredate == 726
*August 
replace unemployrate = 8.4 if ymhiredate == 727
*September
replace unemployrate = 7.9 if ymhiredate == 728
*October
replace unemployrate = 6.9 if ymhiredate == 729
*November 
replace unemployrate = 6.7 if ymhiredate == 730
*December 
replace unemployrate = 6.7 if ymhiredate == 731

*2021
*January
replace unemployrate = 6.3 if ymhiredate == 732
*February 
replace unemployrate = 6.2 if ymhiredate == 733
*March
replace unemployrate = 6.1 if ymhiredate == 734
*April 
replace unemployrate = 6.1 if ymhiredate == 735
*May
replace unemployrate = 5.8 if ymhiredate == 736
*June 
replace unemployrate = 5.9 if ymhiredate == 737
*July 
replace unemployrate = 5.4 if ymhiredate == 738
*August 
replace unemployrate = 5.2 if ymhiredate == 739
*September
replace unemployrate = 4.8 if ymhiredate == 740
*October
replace unemployrate = 4.5 if ymhiredate == 741
*November 
replace unemployrate = 4.2 if ymhiredate == 742
*December 
replace unemployrate = 3.9 if ymhiredate == 743

*2022 last survey year
*January
replace unemployrate = 4.0 if ymhiredate == 744
*February 
replace unemployrate = 3.8 if ymhiredate == 745
*March
replace unemployrate = 3.6 if ymhiredate == 746
*April 
replace unemployrate = 3.6 if ymhiredate == 747
*May
replace unemployrate = 3.6 if ymhiredate == 748
*June 
replace unemployrate = 3.6 if ymhiredate == 749
*July 
replace unemployrate = 3.5 if ymhiredate == 750
*August 
replace unemployrate = 3.7 if ymhiredate == 751
*September
replace unemployrate = 3.5 if ymhiredate == 752
*October
replace unemployrate = 3.7 if ymhiredate == 753
*November 
replace unemployrate = 3.6 if ymhiredate == 754
*December 
replace unemployrate = 3.5 if ymhiredate == 755

*Dropping observations for age not recorded - cannot accurately measure agehire without age.
drop if missing(age)

*Creating variable for age when getting job, i.e. age at ymhiredate
gen agehire = age - yearsjob

* Keeping observations only of target group; young adults
drop if age > 29 | agehire > 29

* Produce a bar graph for this t-test
graph bar (mean) nepobaby (mean) highu, over(ymhiredate)

* Dummy variable for nepobabies being hired during high unemployment
gen nepo_high25 = (nepobaby == 1 & unemployrate >= 5.8)

* Dummy variable for nepobabies being hired during high unemployment
gen nepo_low75 = (nepobaby == 1 & unemployrate < 5.8)

* Testing the hypothesis: it fails
ttest nepo_high25 == nepo_low75

* Checking different unemployment levels

* High unemployment considered above 4.9. or above the median.
gen nepo_high50 = (nepobaby == 1 & unemployrate > 4.9)

* Low unemployment considered at or below 4.9. or the median.
gen nepo_low50 = (nepobaby == 1 & unemployrate <= 4.9)

* Testing the difference of means between the two 
ttest nepo_high50 == nepo_low50

* Visual of the difference in means
 graph bar (mean) nepo_high50 (mean) nepo_low50
 
 * Sensitivity analysis: minus 3 months
 * Creating a variable that brings the ymhiredate back 3 months
 gen hiredate_minus_3m = ymhiredate - 3
 
 * Creating a variable that gives us the unemployment rate from three months ago.
gen urate_minus3m = .
replace urate_minus3m = unemployrate  ymhiredate == hiredate_minus_3