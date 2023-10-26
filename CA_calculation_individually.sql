/////////////////////////////////////// CAlculation of CA eligibility individually///////////////////////////////////////////////

DELIMITER //
CREATE PROCEDURE CA_eligibility_individually(IN RE VARCHAR(10), IN CO VARCHAR(10))
BEGIN
DECLARE max_quiz1 DECIMAL(5, 2);
DECLARE max_quiz2 DECIMAL(5, 2);
DECLARE Prac DECIMAL(5, 2);
DECLARE Theo DECIMAL(5, 2);
DECLARE Mid_marks DECIMAL(5, 2);
DECLARE result1 DECIMAL(5, 2);
DECLARE result2 DECIMAL(5, 2);
DECLARE Eligibility VARCHAR(15);
DECLARE Final_MidMarks DECIMAL(5, 2);
SELECT MAX(quiz_score) AS max_quiz1
INTO max_quiz1
FROM (
SELECT quiz_01 AS quiz_score FROM quiz_marks WHERE reg_no = RE AND course_code = CO
UNION ALL
SELECT quiz_02 AS quiz_score FROM quiz_marks WHERE reg_no = RE AND course_code = CO
UNION ALL
SELECT quiz_03 AS quiz_score FROM quiz_marks WHERE reg_no = RE AND course_code = CO
UNION ALL
SELECT quiz_04 AS quiz_score FROM quiz_marks WHERE reg_no = RE AND course_code = CO
) AS AllQuizScores;
SELECT MAX(quiz_score) AS max_quiz2
INTO max_quiz2
FROM (
SELECT quiz_01 AS quiz_score FROM quiz_marks WHERE reg_no = RE AND course_code = CO
UNION ALL
SELECT quiz_02 AS quiz_score FROM quiz_marks WHERE reg_no = RE AND course_code = CO
UNION ALL
SELECT quiz_03 AS quiz_score FROM quiz_marks WHERE reg_no = RE AND course_code = CO
UNION ALL
SELECT quiz_04 AS quiz_score FROM quiz_marks WHERE reg_no = RE AND course_code = CO
) AS AllQuizScores
WHERE quiz_score < max_quiz1;
SELECT Practical INTO Prac FROM mid_marks WHERE reg_no = RE AND course_code = CO;
SELECT Theory INTO Theo FROM mid_marks WHERE reg_no = RE AND course_code = CO;
IF Prac IS NULL THEN
SET Mid_marks = Theo;
ELSEIF Theo IS NULL THEN
SET Mid_marks = Prac;
ELSE
SET Mid_marks = Theo + Prac;
END IF;
SET Final_MidMarks = Mid_marks / 100;
SET result1 = (max_quiz1 / 10) + (max_quiz2 / 100) + Final_MidMarks;
SET result2 = result1 * 100;
IF result2 > 50 THEN
SET Eligibility = 'Eligible';
ELSE
SET Eligibility = 'Not Eligible';
END IF;
SELECT RE as registration_No, CO as Course_Code, Eligibility as CA_Eligibility;
END //
DELIMITER ;

CALL  CA_eligibility_individually('TG1010','ICT1222');

////////////////////////////////////// Taking the quiz 2 within the highest marks out of 4 quizzes  //////////////////////////////////////////////////

DELIMITER //
CREATE PROCEDURE GetMaxTwoQuiz_individually(IN RE VARCHAR(10), IN CO VARCHAR(10))
BEGIN
DECLARE max_quiz1 DECIMAL(5, 2);
DECLARE max_quiz2 DECIMAL(5, 2);

SELECT MAX(quiz_score) AS max_quiz1
INTO @max_quiz1
FROM (
SELECT quiz_01 AS quiz_score FROM quiz_marks WHERE reg_no = RE AND course_code = CO
UNION ALL
SELECT quiz_02 AS quiz_score FROM quiz_marks WHERE reg_no = RE AND course_code = CO
UNION ALL
SELECT quiz_03 AS quiz_score FROM quiz_marks WHERE reg_no = RE AND course_code = CO
UNION ALL
SELECT quiz_04 AS quiz_score FROM quiz_marks WHERE reg_no = RE AND course_code = CO
) AS AllQuizScores;

SELECT MAX(quiz_score) AS max_quiz2
INTO @max_quiz2
FROM (
SELECT quiz_01 AS quiz_score FROM quiz_marks WHERE reg_no = RE AND course_code = CO
UNION ALL
SELECT quiz_02 AS quiz_score FROM quiz_marks WHERE reg_no = RE AND course_code = CO
UNION ALL
SELECT quiz_03 AS quiz_score FROM quiz_marks WHERE reg_no = RE AND course_code = CO
UNION ALL
SELECT quiz_04 AS quiz_score FROM quiz_marks WHERE reg_no = RE AND course_code = CO
) AS AllQuizScores
WHERE quiz_score < @max_quiz1;
SELECT RE, CO, @max_quiz1 AS Max_quiz1, @max_quiz2 AS Max_quiz2;
END //
DELIMITER ;

CALL  GetMaxTwoQuiz_individually('TG1010','ICT1222');

///////////////////////////////////////////////////////////////Obtaining MID examination marks Individually ////////////////////////////////////////////////

DELIMITER //
CREATE PROCEDURE Get_Mid_Marks_individually(IN RE VARCHAR(10), IN CO VARCHAR(10))
BEGIN
DECLARE Prac DECIMAL(5,2);
DECLARE Theo DECIMAL(5,2);
DECLARE Mid_marks DECIMAL(5,2);
SELECT Practical INTO Prac FROM mid_marks WHERE reg_no = RE AND course_code = CO;
SELECT Theory INTO Theo FROM mid_marks WHERE reg_no = RE AND course_code = CO;
IF Prac IS NULL THEN
SET Mid_marks = Theo;
ELSEIF Theo IS NULL THEN
SET Mid_marks = Prac;
ELSE
SET Mid_marks = Theo + Prac;
END IF;
SELECT Mid_marks/2 AS Final_MidMarks;
END //
DELIMITER ;

CALL  Get_Mid_Marks_individually('TG1010','ICT1222');




