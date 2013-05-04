#!/usr/bin/env ruby

require 'rexml/document'

file_dir = '/Users/mal/Library/Application Support/Army Builder/data/AB40k6/'
class Dat
  attr_accessor :document
  
  def initialize document
    @document = document
    parse
  end
  
  def data
    @_data ||= {
      options: {},
      units: {},
      linksets: {},
      races: {}
    }
  end
  
  def parse
    document.elements.each('document/option') do |option|
      h = {}
      option.attributes.each do |k,v|
        h[k] = v
      end
      data[:options][option.attributes["id"]] = h
    end

    document.elements.each('document/linkset') do |linkset|
      this_set = {links:{}}
      linkset.elements.each('link') do |link|
        option = link.attributes["option"]
        this_set[:links][option] = {}
        
        link.attributes.each do |k, v|
          this_set[:links][option][k] = v
        end
        if data[:options][option]
        else
          puts "No option " + option.inspect
        end
      end
      data[:linksets][linkset.attributes["id"]] = this_set
    end
    
    document.elements.each('document/race') do |race|
      this_race = {}
      id = race.attributes["id"]
      race.attributes.each do |k, v|
        this_race[k] = v
      end
      data[:races][id] = this_race
    end

    document.elements.each('document/unit') do |el|
      unit = {characteristics: {}, linkrefs: [], links: {}}
      el.attributes.each do |k,v|
        unit[k] = v
      end

      # Characteristics
      el.elements.each('statval') do |stat|
        unit[:characteristics][stat.attributes["stat"]] = stat.attributes["value"]
      end

      # LinkRef
      # Add all items in link ref
      # Options
      # TODO: Get any other entities which are units and add to same squad. Units here = models
      el.elements.each('link') do |link|
        option = link.attributes["option"]
        case option
        when "gnRef"
          unit[:ref] = link.attributes["name"]
        end
        unit[:links][option] = {}
        link.attributes.each do |k,v|
          unit[:links][option][k] = v
        end
      end

      # Tags
      el.elements.each('tag') do |tag|
        group = tag.attributes["group"]
        value = tag.attributes["tag"]
        case group
        when "Group"
            unit[:group] = value
        when "UnitTags"
          unit[:type] = value
        when "race"
          unit[:race] = value
        end
      end
      
      el.elements.each("linkref") do |ref|
        id = ref.attributes["id"]
        unit[:linkrefs] << id
        unless data[:linksets][id]
          puts "Linkset bad " + id
        end
      end
      data[:units][unit["id"]] = unit
    end
  end
end

def render unit, data
  puts unit["name"]
  unit[:links].each do |option, link|
    full_option = data[:options][option]
    unless full_option
      puts "Missing option " + option
      next
    end
    if full_option["unit"]
      puts "Includes unit " + full_option["unit"]
      puts data[:units][full_option["unit"]].inspect
    else
      puts data[:options][option]
    end
  end
end


class ArmyData
  attr_accessor :data
  def initialize data
    @data = data
  end
  
  def units_for_race race_id
    data[:units].reject do |k,v|
      v[:race] != race_id
    end
  end
end






filenames = %w{ general6Dat.dat sm5EDat.dat warhammer6-40k.def }

dats = filenames.map do |filename|
  Dat.new REXML::Document.new File.read(file_dir + filename)
end

data = ArmyData.new(dats.inject({
  options: {},
  units: {},
  races: {},
  linksets: {}
}) do |h, dat|
  h[:options].merge! dat.data[:options]
  h[:units].merge! dat.data[:units]
  h[:linksets].merge! dat.data[:linksets]
  h[:races].merge! dat.data[:races]
  h
end)

#puts data[:options].size.inspect
#data[:units].each do |name,unit|
#  render unit, data if unit["name"] =~ /tactical/i
#end

data.units_for_race('sm').each do |id, unit|
  puts unit["name"].inspect
end
