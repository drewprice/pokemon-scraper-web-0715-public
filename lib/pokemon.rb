class Pokemon
  def self.save_from_nokogiri(obj, db)
    name  = obj.css('a.ent-name').text
    types = obj.css('a.itype').map(&:text)

    # TODO: split types into a many-to-many table
    save(name, types.join, db)
  end

  def self.save(name, type, db)
    db.execute('INSERT INTO pokemon (name, type) VALUES (?, ?)',
               "#{name}", "#{type}")
  end

  def self.find(id, db)
    data = db.execute('SELECT * FROM pokemon WHERE id = ?',
                      "#{id}").flatten

    create_from_data(id: data[0],
                     name: data[1],
                     type: data[2],
                     db: db)
  end

  def self.create_from_data(id:, name:, type:, db:)
    new.tap do |pokemon|
      pokemon.id = id
      pokemon.name  = name
      pokemon.type = type
      pokemon.db = db
    end
  end

  attr_accessor :id, :name, :type, :db

  def alter_hp(new_value)
    db.execute('UPDATE pokemon SET hp = ? WHERE id = ?;',
               "#{new_value}",
               "#{id}")
  end
end
