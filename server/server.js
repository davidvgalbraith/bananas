var express = require('express');
var Promise = require('bluebird');
var mysql = require('mysql');
var body_parser = require('body-parser');

var EventServer = function() {
    return {
        start: function(options) {
            var self = this;
            this.sql_connection = Promise.promisifyAll(mysql.createConnection(options.sql_options));
            return this.sql_connection.connectAsync()
                .then(function() {           
                    var app = express();

                    app.get('/events', body_parser.json(), function (req, res) {
                        return self.sql_connection.queryAsync('SELECT * FROM events')
                            .then(function(events) {
                                res.end(JSON.stringify({events: events[0]}));
                            })
                            .catch(function(err) {
                                console.error(err, err.stack);
                                res.sendStatus(400);
                            });
                    });
                    
                    app.post('/events', body_parser.json(), function(req, res) {
                        var events = req.body;
                        if (!Array.isArray(events)) {
                            events = [events];
                        }
                        return Promise.each(events, function(event) {
                            return self.sql_connection.queryAsync('INSERT INTO events SET ?', event)
                                .then(function() { 
                                    res.sendStatus(201);
                                })
                                .catch(function(err) {
                                    console.error(err, err.stack);
                                    res.sendStatus(400);
                                });
                        });
                    });
                    
                    return new Promise(function(resolve, reject){     
                        self.server = app.listen(3000, resolve);
                    });
                });
        },
        
        stop: function() {
            if (!this.server) { 
                return;
            }
            this.server.close();
        }
    }
};

module.exports = EventServer;
