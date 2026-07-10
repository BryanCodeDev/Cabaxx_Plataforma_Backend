const BaseRepository = require('./baseRepository');
const EventModel = require('../models/Event.model');

class EventRepository extends BaseRepository {
  constructor() {
    super(EventModel);
  }
}

module.exports = new EventRepository();
