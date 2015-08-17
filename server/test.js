var Promise = require('bluebird');
var request = Promise.promisifyAll(require('request'));
var expect = require('chai').expect;
var mysql = require('mysql');
var _ = require('underscore');

var EventServer = require('./server');

describe('social event server', function() {
    var event = {
        name: 'dave',
        blurb: 'an event',
        event_description: 'come party with me at this silly event'
    };

    var server = new EventServer();
    var connection;

    before(function() {
        var sql_options = {
            host: 'localhost',
            port: 3306,
            user: 'root',
            password: 'Irys2015',
            //debug: true
        };

        connection = Promise.promisifyAll(mysql.createConnection(sql_options));

        return connection.connectAsync()
            .then(function() {
                return connection.queryAsync('CREATE DATABASE IF NOT EXISTS dave');
            })
            .then(function() {
                return connection.queryAsync('USE dave');
            })
            .then(function() {
                return connection.queryAsync('CREATE TABLE IF NOT EXISTS events  (id int(11) NOT NULL AUTO_INCREMENT, blurb varchar(255), event_description varchar(1000), name varchar(255), PRIMARY KEY (id))');
            })
            .then(function() {
                sql_options.database = 'dave';
                return server.start({
                    sql_options: sql_options
                });
            });
    });

    after(function() {
        server.stop();
        return connection.queryAsync('DROP DATABASE dave');
    });

    it('posts an event', function() {
        var url = 'http://localhost:3000/events';
        return request.postAsync({
            url: url,
            json: event
        })
        .spread(function(res, body) {
            expect(res.statusCode).equal(201);
        });
    });
   
    it('retrieves that event', function() {
        var url = 'http://localhost:3000/events';
        return request.getAsync(url)
            .spread(function(res, body) {
                body = JSON.parse(body);
                expect(res.statusCode).equal(200);
                
                var events = body.events;
                expect(events.length).equal(1);
                var e = _.omit(events[0], 'id');
                expect(e).deep.equal(event);
                expect(events[0].id).equal(1);
            });
    });
});
