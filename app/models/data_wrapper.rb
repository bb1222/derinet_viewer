class DataWrapper

  def initialize

    path = "#{File.dirname(__FILE__)}/../../data/derinet.txt"

    @data = {}

    @name_to_id = {}

    @suggestions = {}

    File.open(path).each do |line|
      line.chomp!
      line.strip!

      parts = line.split(/[\t ]+/)

      el = {}
      el["children"] = []
      el["id"] = parts[0].to_i
      el["parent"] = nil
      el["parent"] = parts[4].to_i if parts[4]
      el["word"] = parts[1]
      el["lemma"] = parts[2]
      el["pos"] = parts[3]

      @name_to_id[el["word"]] = el["id"]
      @name_to_id[el["lemma"]] = el["id"]

      @data[el["id"]] = el

    end

    @data.each do |k, v|
      if @data[v["parent"]] != nil
        @data[v["parent"]]["children"].push(k)
      end
    end

    #@data.each do |k, v|
    #  puts v
    #end
    
    make_suggestions

  end

  def make_suggestions
    @name_to_id.each do |k, v|
      @suggestions[k] = [k]
    end

    @name_to_id.each do |k, v|
      max_length = 10

      1.upto(k.length - 1) do |i|
        str = k[0,i]
        @suggestions[str] = [] unless @suggestions.has_key? str
        @suggestions[str].push(k) if @suggestions[str].size < max_length
      end
    end

    @name_to_id.each do |k, v|
      @suggestions[k] = [] if @suggestions[k].size == 1
    end

  end

  def get_suggestions prefix
    if @suggestions.has_key? prefix
      return @suggestions[prefix]
    else
      return []
    end
  end

  def get_name_to_id
    return @name_to_id
  end

  def get_data
    return @data
  end

  def get_tree word
    id = @name_to_id[word]
    return {name: "Word \"#{word}\" not found"} if id == nil

    el = @data[id]
    while (el["parent"] != nil) do
      el = @data[el["parent"]]
    end

    return get_tree_node(el["id"])
  end

  def get_tree_node id
    ret = {}
    el = @data[id]
    ret["name"] = el["lemma"]
    if el["children"].size > 0
      ret["children"] = []
      el["children"].each do |cid|
        ret["children"].push(get_tree_node(cid))
      end
    end
    return ret
  end

end