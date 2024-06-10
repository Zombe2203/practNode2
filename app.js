// католог с модулем для синхр. работы с MySQL, который должен быть усталовлен командой: sync-mysql
const dir_nms = 'D:\\Zombes_folder\\Soft\\nodejs\\node_modules\\sync-mysql';

// работа с базой данных.
const Mysql = require(dir_nms)
const connection = new Mysql({
    host:'localhost',
    port:'8080',
    user:'root', 
    password:'12345', 
    database:'lookout'
})

// обработка параметров из формы.
var qs = require('querystring');
function reqPost (request, response) {
    if (request.method == 'POST') {
        var body = '';

        request.on('data', function (data) {
            body += data;
        });

        request.on('end', function () {
			var post = qs.parse(body);
			var sInsert = "INSERT INTO sectors (coordinates, luminous, obstacles, objects_number, unidentified_objects, identified_objects, observ_date, notes) VALUES (\""+post['col1']+"\",\""+post['col2']+"\",\""+post['col3']+"\",\""+post['col4']+"\",\""+post['col5']+"\",\""+post['col6']+"\",\""+post['col7']+"\",\""+post['col8']+"\")";
			var results = connection.query(sInsert);
            console.log('Done. Hint: '+sInsert);
        });
    }
}

// выгрузка массива данных.
function ViewSelect(res) {
	var results = connection.query('SHOW COLUMNS FROM sectors;');
	var results1 = connection.query('SHOW COLUMNS FROM positions;');
	res.write('<tr>');

	for(let i=0; i < results.length; i++)
		res.write('<td>'+results[i].Field+'</td>');
	for(let i=0; i < results1.length; i++)
		res.write('<td>'+results1[i].Field+'</td>');
	res.write('</tr>');

	var results = connection.query('CALL proc1("Sectors", "Positions");');
	for(let i=0; i < results.length-1; i++)
		res.write('<tr><td>'+results[i][0].id+
		      '</td><td>'+results[i][0].coordinates+
			  '</td><td>'+results[i][0].luminous+
			  '</td><td>'+results[i][0].obstacles+
			  '</td><td>'+results[i][0].objects_number+
			  '</td><td>'+results[i][0].unidentified_objects+
			  '</td><td>'+results[i][0].identified_objects+
			  '</td><td>'+String(results[i][0].observ_date)+
			  '</td><td>'+results[i][0].notes+
			  '</td><td>'+results[i][0].id+
			  '</td><td>'+results[i][0].earth_pos+
			  '</td><td>'+results[i][0].sol_pos+
			  '</td><td>'+results[i][0].moon_pos+
			  '</td></tr>');
}
function ViewVer(res) {
	var results = connection.query('SELECT VERSION() AS ver');
	res.write(results[0].ver);
}

// создание ответа в браузер, на случай подключения.
const http = require('http');
const server = http.createServer((req, res) => {
	reqPost(req, res);
	console.log('Loading...');
	
	res.statusCode = 200;
//	res.setHeader('Content-Type', 'text/plain');

	// чтение шаблока в каталоге со скриптом.
	var fs = require('fs');
	var array = fs.readFileSync(__dirname+'\\select.html').toString().split("\n");
	console.log(__dirname+'\\select.html');
	for(i in array) {
		// подстановка.
		if ((array[i].trim() != '@tr') && (array[i].trim() != '@ver')) res.write(array[i]);
		if (array[i].trim() == '@tr') ViewSelect(res);
		if (array[i].trim() == '@ver') ViewVer(res);
	}
	res.end();
	console.log('1 User Done.');
});

// запуск сервера, ожидание подключений из браузера.
const hostname = '127.0.0.1';
const port = 3000;
server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
