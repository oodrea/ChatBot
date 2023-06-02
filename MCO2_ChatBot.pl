:- dynamic(askedsymp/1).
:- dynamic(has/1).
:- dynamic(hasnot/1).


/*Initializes program*/
begin():-
	retractall(has(_)),
	assert(has([])),
	retractall(hasnot(_)),
	assert(hasnot([])),
	retractall(askedsymp(_)),
	assert(askedsymp([])),
	format('System: ~nWelcome to TalkTor! ~nWe will ask you a few questions about your symptoms.~n>If you feel like you have provided enough information, feel free to enter \'d\' to get a diagnosis immediately.~n>Otherwise, enter \'q\' if you wish to abort the current session. ~n~nTalkTor:~nWith that out of the way, we will now begin the diagnosis process.~n'),
	askSymptom('cough')
	.

/*Takes in user input*/
askSymptom(X):-
	format("~nTalkTor:~nDo you ~w? y/n/q/d: ~n", [X]),
	read(AnswerSymptom),
	(AnswerSymptom == q ->abort();
	 AnswerSymptom == y -> affirmSymptom(X);
	 AnswerSymptom == n -> negateSymptom(X);
	 AnswerSymptom == d -> diagnosebegin()
	 ).	 

/*Processes Symptoms*/
affirmSymptom(X):-
	has(H), append(H, [X], HX), assert(has(HX)), retract(has(H)),
	askedsymp(L), append(L, [X], LX), assert(askedsymp(LX)), retract(askedsymp(L)),
	findall(Y,(related(X, Y), askedsymp(N), \+member(Y, N)), R),
	(R == [] -> diagnosebegin();
	 random_member(Q, R)),
	askSymptom(Q).

negateSymptom(X):-
    hasnot(N), append(N, [X], NX), assert(hasnot(NX)), retract(hasnot(N)),
    askedsymp(L), append(L, [X], LX), assert(askedsymp(LX)), retract(askedsymp(L)),
    diarrhea(D), hypertension(H), tuberculosis(T), asthma(A), cholera(C), dengue(DE),
    malaria(M), flu(F), chickenpox(CP), measles(MS),
    append(D, H, DH), append(DH, T, DHT), append(DHT, A, DHTA), append(DHTA, C, DHTAC),
    append(DHTAC, DE, DHTACD), append(DHTACD, M, DHTACDM), append(DHTACDM, F, DHTACDF),
    append(DHTACDF, CP, DHTACDFCP), append(DHTACDFCP, MS, DHTACDFCPMS),
    askedsymp(S),
    findall(Y,(member(Y,DHTACDFCPMS), \+member(Y, S)), R),
    (R == [] -> diagnosebegin();
    random_member(Q, R)),
    askSymptom(Q).

/*Starts the diagnosis*/
diagnosebegin():-
	format('~nTalkTor: ~nYour compliance was much appreciated. I have completed the diagnosis process.~nHere is my analysis: ~n'),
	diagnose().

/*Diagnoses user's disease*/
diagnose():-
	diagnoseasthma();
	diagnosecholera();
	diagnosemeasles();
	diagnosechickenpox();
	diagnosetuberculosis();
	diagnosediarrhea();
	diagnosedengue();
	diagnoseflu();
	diagnosemalaria();
	diagnosedhypertension();
	

	/*If no diagnosis could be made*/
	format('~n>Unfortunately, I was unable to draw any conclusion based on the information you provided. Please try again later.~n'),
	diagnoseEnd().

/*Prints end message and aborts program*/
diagnoseEnd():-
	format("~nSystem:~nThank you for using our service! You can start another consultation for other diseases now. ~n"),
	abort().
	
/*Disease Diagnosis: The predicates below take the symptom present( in has() ) and compares it with the symptoms of a certain disease.*/	
diagnosediarrhea():-
	has(H),diarrhea(C), intersection(H, C, R), length(R, L),
	(L >= 4 -> format('~n>You might have diarrhoeal disease.~n~nDiarrhoeal disease is an infectious condition that affects the digestive system and causes frequent watery bowel movements, often accompanied by cramps and abdominal pain.~nIt can be caused by viruses, bacteria, or parasites, and can be transmitted through contaminated food or water, or by person-to-person contact.~n')),
	diagnoseEnd().
	
diagnosedhypertension():-
	has(H),hypertension(C), intersection(H, C, R), length(R, L),
	(L >= 7 -> format('~n>You might have hypertension.~n~nHypertension, also known as high blood pressure, is a chronic medical condition in which the force of blood against the walls of the arteries is consistently too high.~nIt can increase the risk of serious health problems such as heart disease, stroke, and kidney failure.~n')),
	diagnoseEnd().

diagnosetuberculosis():-
	has(H),tuberculosis(C), intersection(H, C, R), length(R, L),
	(L >= 4 -> format('~n>You might have tuberculosis.~n~nTuberculosis (TB) is a bacterial infection that primarily affects the lungs but can also affect other parts of the body.~nIt spreads through the air when an infected person coughs or sneezes, and can cause symptoms such as cough, fever, night sweats, and weight loss.~n')),
	diagnoseEnd().

diagnoseasthma():-
	has(H),asthma(C), intersection(H, C, R), length(R, L),
	(L >= 2 -> format('~n>You might have asthma.~n~nAsthma is a chronic respiratory condition characterized by inflammation and narrowing of the airways, leading to symptoms such as wheezing, coughing, and difficulty breathing.~nIt can be triggered by various factors such as allergens, exercise, or stress.~n')),
	diagnoseEnd().

diagnosecholera():-
	has(H),cholera(C), intersection(H, C, R), length(R, L),
	(L >= 3 -> format('~n>You might have cholera.~n~nCholera is an acute diarrheal disease caused by the bacterium Vibrio cholerae, which is transmitted through contaminated food or water.~nIt can cause severe dehydration and can be fatal if left untreated.~n')),
	diagnoseEnd().

diagnosedengue():-
	has(H),dengue(C), intersection(H, C, R), length(R, L),
	(L >= 4 -> format('~n>You might have dengue.~n~nDengue is a viral infection spread by mosquitoes that can cause flu-like symptoms such as fever, headache, and joint pain.~nIn severe cases, it can lead to a potentially life-threatening condition called dengue hemorrhagic fever.~n')),
	diagnoseEnd().

diagnosemalaria():-
	has(H),malaria(C), intersection(H, C, R), length(R, L),
	(L >= 5 -> format('~n>You might have malaria.~n~nMalaria is a parasitic infection transmitted by mosquitoes that can cause fever, chills, and flu-like symptoms.~nIn severe cases, it can lead to life-threatening complications such as organ failure and cerebral malaria.~n')),
	diagnoseEnd().

diagnoseflu():-
	has(H),flu(C), intersection(H, C, R), length(R, L),
	(L >= 5 -> format('~n>You might have flu.~n~nFlu, or influenza, is a contagious respiratory illness caused by influenza viruses.~nIt can cause symptoms such as fever, cough, sore throat, body aches, and fatigue, and can lead to complications such as pneumonia.~n')),
	diagnoseEnd().

diagnosemeasles():-
	has(H),measles(C), intersection(H, C, R), length(R, L),
	(L >= 3 -> format('~n>You might have measles.~n~nMeasles is a highly contagious viral infection that causes a characteristic rash, fever, and other symptoms such as cough and runny nose.~nIt can be prevented by vaccination.~n')),
	diagnoseEnd().

diagnosechickenpox():-
	has(H),chickenpox(C), intersection(H, C, R), length(R, L),
	(L >= 3 -> format('~n>You might have chicken pox.~n~nChickenpox is a viral infection that causes an itchy rash and fluid-filled blisters.~nIt can be spread through the air or by contact with fluid from the blisters. A vaccine is available to prevent chickenpox.~n')),
	diagnoseEnd().

/*Used for Checking Relations*/
related(X, Y):-	
	diarrhea(L), member(X, L), member(Y, L);
	hypertension(L), member(X, L), member(Y, L);
	tuberculosis(L), member(X, L), member(Y, L);
	asthma(L), member(X, L), member(Y, L);
	cholera(L), member(X, L), member(Y, L);
	dengue(L), member(X, L), member(Y, L);
	malaria(L), member(X, L), member(Y, L);
	flu(L), member(X, L), member(Y, L);
	chickenpox(L), member(X, L), member(Y, L);
	measles(L), member(X, L), member(Y, L).

/*Selects a Random Symptom*/
randomSymptom(X):-
    diarrhea(D), hypertension(H), tuberculosis(T), asthma(A), cholera(C),
    dengue(De), malaria(M), flu(F), chickenpox(CP), measles(Me),
    append(D, H, DH), append(DH, T, DHT), append(DHT, A, DHTA), append(DHTA, C, DHTAC),
    append(DHTAC, De, DHTACDe), append(DHTACDe, M, DHTACDeM), append(DHTACDeM, F, DHTACDeMF),
    append(DHTACDeMF, CP, DHTACDeMFCP), append(DHTACDeMFCP, Me, DHTACDeMFCPMe),
    random_member(X, DHTACDeMFCPMe).

list_empty([], true).
list_empty([_|_], false).


/*Symptoms of the Diseases*/
measles(['have fever', 'cough', 'have runny nose or stuffy nose', 'have sore throat', 'have reddish eyes']).
asthma(['have shortness of breath', 'have chest tightness', 'cough', 'wheeze']).
chickenpox(['have fever', 'have headaches', 'lose appetite', 'often experience fatigue', 'have fluid-filled rash']).
cholera(['have watery stool', 'vomit often', 'have excessive thirst', 'have leg cramps', 'experience restless or irritability']).
diarrhea(['have watery stool', 'have excessive thirst', 'have excessive dizziness', 'experience confusion', 'urinate less', 'have sunken eyeball/s']).
hypertension(['have severe headaches', 'have chest pain', 'have excessive dizziness', 'have shortness of breath', 'often feel nauseous', 'vomit often', 'have blurry vision', 'experience confusion', 'have anxiety', 'have buzzing in the ears', 'often have nosebleeds', 'experience abnormal heart rhythm']).
tuberculosis(['have a bad cough that lasts 3 weeks or longer', 'have chest pain', 'cough up blood', 'often experience fatigue', 'have weight loss', 'lose appetite', 'have chills']).
dengue(['have headaches', 'have severe pain behind the eyes', 'have body ache', 'have rash', 'bruise easily', 'often have nosebleeds']).
malaria(['have fever', 'have chills', 'have headaches', 'have body ache', 'often experience fatigue', 'often feel nauseous', 'vomit often', 'have watery stool', 'have yellowish skin/eyes']).
flu(['have fever', 'cough', 'have sore throat', 'have runny or stuffy nose', 'have body ache', 'often experience fatigue', 'vomit often', 'have watery stool']).


/*Initializing Lists*/
askedsymp([]).
has([]).
hasnot([]).
