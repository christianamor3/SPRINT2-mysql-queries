-- 1. Retorna un llistat amb el primer cognom, segon cognom i el nom de tots els/les alumnes. El llistat haurà d'estar ordenat alfabèticament de menor a major pel primer cognom, segon cognom i nom.
SELECT apellido1 AS PRIMER_APELLIDO, apellido2 AS SEGUNDO_APELLIDO, nombre AS NOMBRE FROM persona WHERE tipo='alumno' ORDER BY apellido1, apellido2, nombre ASC;
-- 2. Esbrina el nom i els dos cognoms dels alumnes que no han donat d'alta el seu número de telèfon en la base de dades.
SELECT nombre AS NOMBRE, apellido1 AS PRIMER_APELLIDO, apellido2 AS SEGUNDO_APELLIDO FROM persona WHERE tipo='alumno' AND telefono is null;
-- 3. Retorna el llistat dels alumnes que van néixer en 1999.
SELECT * FROM persona WHERE tipo='alumno' AND fecha_nacimiento LIKE '%1999%';
-- 4. Retorna el llistat de professors/es que no han donat d'alta el seu número de telèfon en la base de dades i a més el seu NIF acaba en K.
SELECT * FROM persona WHERE tipo='profesor' AND telefono is null AND nif LIKE '%K';
-- 5. Retorna el llistat de les assignatures que s'imparteixen en el primer quadrimestre, en el tercer curs del grau que té l'identificador 7
SELECT * FROM asignatura WHERE cuatrimestre=1 AND curso=3 AND id_grado=7;
-- 6. Retorna un llistat dels professors/es juntament amb el nom del departament al qual estan vinculats. El llistat ha de retornar quatre columnes, primer cognom, segon cognom, nom i nom del departament. El resultat estarà ordenat alfabèticament de menor a major pels cognoms i el nom.
SELECT p.apellido1 AS PRIMER_APELLIDO, p.apellido2 AS SEGUNDO_APELLIDO, p.nombre AS NOMBRE, d.nombre AS NOMBRE_DEPARTAMENTO FROM persona p JOIN profesor pr ON p.id=pr.id_profesor JOIN departamento d ON pr.id_departamento=d.id WHERE p.tipo='Profesor' ORDER BY apellido1, apellido2, nombre;
-- 7. Retorna un llistat amb el nom de les assignatures, any d'inici i any de fi del curs escolar de l'alumne/a amb NIF 26902806M.
SELECT a.nombre AS NOMBRE_ASIGNATURA, ce.anyo_inicio AS ANYO_INICIO, ce.anyo_fin AS ANYO_FIN FROM asignatura a JOIN alumno_se_matricula_asignatura asma ON a.id=asma.id_asignatura JOIN curso_escolar ce ON asma.id_curso_escolar=ce.id JOIN persona p ON asma.id_alumno=p.id WHERE p.tipo='alumno' AND nif = '26902806M';
-- 8. Retorna un llistat amb el nom de tots els departaments que tenen professors/es que imparteixen alguna assignatura en el Grau en Enginyeria Informàtica (Pla 2015).
SELECT distinct d.nombre AS NOMBRE_DEPARTAMENTO FROM departamento d JOIN profesor p ON d.id=p.id_departamento JOIN asignatura a ON p.id_profesor=a.id_profesor JOIN grado g ON a.id_grado=g.id WHERE g.nombre='Grado en Ingeniería Informática (Plan 2015)';
-- 9. Retorna un llistat amb tots els alumnes que s'han matriculat en alguna assignatura durant el curs escolar 2018/2019.
SELECT distinct p.* FROM persona p JOIN alumno_se_matricula_asignatura asma ON p.id=asma.id_alumno JOIN curso_escolar ce ON asma.id_curso_escolar=ce.id WHERE asma.id_asignatura is not null AND p.tipo='alumno' AND ce.anyo_inicio=2018 AND ce.anyo_fin=2019;
-- Resol les 6 següents consultes utilitzant les clàusules LEFT JOIN i RIGHT JOIN.
-- 1. Retorna un llistat amb els noms de tots els professors/es i els departaments que tenen vinculats. El llistat també ha de mostrar aquells professors/es que no tenen cap departament associat. El llistat ha de retornar quatre columnes, nom del departament, primer cognom, segon cognom i nom del professor/a. El resultat estarà ordenat alfabèticament de menor a major pel nom del departament, cognoms i el nom.
SELECT d.nombre AS NOMBRE_DEPARTAMENTO, p.apellido1 AS PRIMER_APELLIDO, p.apellido2 AS SEGUNDO_APELLIDO, p.nombre AS NOMBRE FROM persona p LEFT JOIN profesor pr ON p.id=pr.id_profesor LEFT JOIN departamento d ON pr.id_departamento=d.id WHERE p.tipo='profesor' ORDER BY d.nombre, p.apellido1, p.apellido2, p.nombre ASC;
-- 2. Retorna un llistat amb els professors/es que no estan associats a un departament.
SELECT p.apellido1 AS PRIMER_APELLIDO, p.apellido2 AS SEGUNDO_APELLIDO, p.nombre AS NOMBRE FROM persona p LEFT JOIN profesor pr ON p.id=pr.id_profesor WHERE p.tipo='profesor' AND pr.id_departamento is null;
-- 3. Retorna un llistat amb els departaments que no tenen professors/es associats.
SELECT d.* FROM profesor pr RIGHT JOIN departamento d ON d.id=pr.id_departamento WHERE pr.id_profesor is null;
-- 4. Retorna un llistat amb els professors/es que no imparteixen cap assignatura.
SELECT p.* FROM persona p LEFT JOIN profesor pr ON p.id=pr.id_profesor LEFT JOIN asignatura a ON pr.id_profesor=a.id_profesor WHERE p.tipo='profesor' AND a.id_profesor is null;
-- 5. Retorna un llistat amb les assignatures que no tenen un professor/a assignat.
SELECT a.nombre, p.nombre FROM persona p RIGHT JOIN asignatura a  ON a.id_profesor=p.id WHERE p.id is null;
-- 6. Retorna un llistat amb tots els departaments que no han impartit assignatures en cap curs escolar.
SELECT DISTINCT d.nombre FROM profesor pr RIGHT JOIN departamento d ON d.id=pr.id_departamento LEFT JOIN asignatura a ON pr.id_profesor=a.id_profesor WHERE a.id is null OR a.id_profesor is null;
-- Consultes resum
-- 1. Retorna el nombre total d'alumnes que hi ha.
SELECT COUNT(p.id) AS NUM_TOTAL_ALUMNES FROM persona p WHERE tipo='alumno';
-- 2. Calcula quants alumnes van néixer en 1999.
SELECT COUNT(p.id) AS NUM_TOTAL_ALUMNES FROM persona p WHERE tipo='alumno' AND p.fecha_nacimiento LIKE '%1999%';
-- 3. Calcula quants professors/es hi ha en cada departament. El resultat només ha de mostrar dues columnes, una amb el nom del departament i una altra amb el nombre de professors/es que hi ha en aquest departament. El resultat només ha d'incloure els departaments que tenen professors/es associats i haurà d'estar ordenat de major a menor pel nombre de professors/es.
SELECT d.nombre AS NOMBRE_DEPARTAMENTO, COUNT(pr.id_profesor) AS NUM_TOTAL_PROFES FROM departamento d JOIN profesor pr ON d.id=pr.id_departamento GROUP BY d.id ORDER BY COUNT(pr.id_profesor) DESC;
-- 4. Retorna un llistat amb tots els departaments i el nombre de professors/es que hi ha en cadascun d'ells. Tingui en compte que poden existir departaments que no tenen professors/es associats. Aquests departaments també han d'aparèixer en el llistat.
SELECT d.nombre AS NOMBRE_DEPARTAMENTO, COUNT(pr.id_profesor) AS NUM_TOTAL_PROFES FROM departamento d LEFT JOIN profesor pr ON d.id=pr.id_departamento GROUP BY d.id;
-- 5. Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun. Tingues en compte que poden existir graus que no tenen assignatures associades. Aquests graus també han d'aparèixer en el llistat. El resultat haurà d'estar ordenat de major a menor pel nombre d'assignatures.
SELECT g.nombre AS NOMBRE_GRADO, COUNT(a.id) AS NUM_TOTAL_ASIGNATURAS FROM grado g LEFT JOIN asignatura a ON g.id=a.id_grado GROUP BY g.id ORDER BY NUM_TOTAL_ASIGNATURAS DESC;
-- 6. Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun, dels graus que tinguin més de 40 assignatures associades.
SELECT g.nombre AS NOMBRE_GRADO, COUNT(a.id) AS NUM_TOTAL_ASIGNATURAS FROM grado g LEFT JOIN asignatura a ON g.id=a.id_grado GROUP BY g.id HAVING NUM_TOTAL_ASIGNATURAS > 40;
-- 7. Retorna un llistat que mostri el nom dels graus i la suma del nombre total de crèdits que hi ha per a cada tipus d'assignatura. El resultat ha de tenir tres columnes: nom del grau, tipus d'assignatura i la suma dels crèdits de totes les assignatures que hi ha d'aquest tipus.
SELECT g.nombre AS NOMBRE_GRADO, a.tipo AS TIPO_ASIGNATURA, SUM(a.creditos) AS SUMA_CREDITOS FROM grado g JOIN asignatura a ON g.id=a.id_grado GROUP BY g.id, a.tipo;
-- 8. Retorna un llistat que mostri quants alumnes s'han matriculat d'alguna assignatura en cadascun dels cursos escolars. El resultat haurà de mostrar dues columnes, una columna amb l'any d'inici del curs escolar i una altra amb el nombre d'alumnes matriculats.
SELECT ce.anyo_inicio AS ANYO_INICIO, COUNT(asma.id_alumno) AS NUM_ALUMES_MATRICULATS FROM alumno_se_matricula_asignatura asma RIGHT JOIN curso_escolar ce ON ce.id=asma.id_curso_escolar GROUP BY ce.id;
-- 9. Retorna un llistat amb el nombre d'assignatures que imparteix cada professor/a. El llistat ha de tenir en compte aquells professors/es que no imparteixen cap assignatura. El resultat mostrarà cinc columnes: id, nom, primer cognom, segon cognom i nombre d'assignatures. El resultat estarà ordenat de major a menor pel nombre d'assignatures.
SELECT p.id AS ID, p.nombre AS NOMBRE, p.apellido1 AS PRIMER_APELLIDO, p.apellido2 AS SEGUNDO_APELLIDO, COUNT(a.id) AS NUM_ASIGNATURES FROM persona p LEFT JOIN asignatura a ON p.id=a.id_profesor WHERE p.tipo='PROFESOR' GROUP BY p.id ORDER BY NUM_ASIGNATURES DESC;
-- 10. Retorna totes les dades de l'alumne/a més jove.
SELECT * FROM persona p WHERE tipo='alumno' ORDER BY fecha_nacimiento DESC limit 1;
-- 11. Retorna un llistat amb els professors/es que tenen un departament associat i que no imparteixen cap assignatura.
SELECT p.nombre AS NOMBRE, p.apellido1 AS PRIMER_APELLIDO, p.apellido2 AS SEGUNDO_APELLIDO FROM persona p LEFT JOIN profesor pr ON p.id=pr.id_profesor LEFT JOIN asignatura a ON pr.id_profesor=a.id_profesor WHERE pr.id_departamento is not null AND a.id is null GROUP BY p.id,pr.id_profesor;