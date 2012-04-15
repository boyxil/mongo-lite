require './helper'
mongo = require '../lib/driver'

describe "Collection", ->
  beforeEach (next) ->
    @db = mongo.db('test')
    @db.clear next

  sync.it "should create", ->
    units = @db.collection 'units'
    unit = name: 'Probe',  status: 'alive'
    expect(units.create(unit)).not.to.be undefined
    expect(unit.id).to.be.a 'string'
    expect(units.first(name: 'Probe').status).to.eql 'alive'

  sync.it "should update", ->
    units = @db.collection 'units'
    unit = name: 'Probe',  status: 'alive'
    units.create unit
    expect(units.first(name: 'Probe').status).to.be 'alive'
    unit.status = 'dead'
    units.update {id: unit.id}, unit
    expect(units.first(name: 'Probe').status).to.be 'dead'
    expect(units.count()).to.be 1

  sync.it "should update in-place", ->
    units = @db.collection 'units'
    units.create name: 'Probe',  status: 'alive'
    expect(units.update({name: 'Probe'}, $set: {status: 'dead'})).to.be 1
    expect(units.first(name: 'Probe').status).to.be 'dead'

  sync.it "should delete", ->
    units = @db.collection 'units'
    units.create name: 'Probe',  status: 'alive'
    expect(units.delete(name: 'Probe')).to.be 1
    expect(units.count(name: 'Probe')).to.be 0

  sync.it "should update all matched by criteria (not just first as default in mongo)", ->
    units = @db.collection 'units'
    units.save name: 'Probe',  race: 'Protoss', status: 'alive'
    units.save name: 'Zealot', race: 'Protoss', status: 'alive'
    units.update {race: 'Protoss'}, $set: {status: 'dead'}
    expect(units.all().map((u) -> u.status)).to.eql ['dead', 'dead']
    units.delete race: 'Protoss'
    expect(units.count()).to.be 0

  sync.it "should use short string id (instead of BSON::ObjectId as default in mongo)", ->
    units = @db.collection 'units'
    unit = name: 'Probe',  status: 'alive'
    units.create unit
    expect(unit.id).to.be.a 'string'