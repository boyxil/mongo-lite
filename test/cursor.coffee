require './helper'
mongo = require '../lib/driver'

describe "Cursor", ->
  beforeEach (next) ->
    @db = mongo.db('test')
    @db.clear next

  flow.it "should return first element", ->
    units = @db.collection 'units'
    expect(units.first()).to.be null
    units.save name: 'Zeratul'
    expect(units.first(name: 'Zeratul').name).to.be 'Zeratul'

  flow.it 'should return all elements', ->
    units = @db.collection 'units'
    expect(units.all()).to.eql []
    units.save name: 'Zeratul'
    list = units.all name: 'Zeratul'
    expect(list).to.have.length 1
    expect(list[0].name).to.be 'Zeratul'

  flow.it 'should return count of elements', ->
    units = @db.collection 'units'
    expect(units.count(name: 'Zeratul')).to.be 0
    units.save name: 'Zeratul'
    units.save name: 'Tassadar'
    expect(units.count(name: 'Zeratul')).to.be 1

  flow.it "should delete via cursor", ->
    units = @db.collection 'units'
    units.create(name: 'Probe',  status: 'alive')
    cursor = units.find(name: 'Probe')
    cursor.delete()
    expect(units.count(name: 'Probe')).to.be 0