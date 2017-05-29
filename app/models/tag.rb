# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  text       :string(255)      default(""), not null
#

class Tag < ApplicationRecord
  
  has_many :taggings

  def Tag.SUPERTAGS
    [
      ["music","music"], 
      ["theatre","theatre"],
      ["art","art"],
      ["comedy","comedy"],
      ["dance","dance"],
      ["movie","movie"],
      ["reading","reading"],
      ["community","community"]
    ]
  end
    
=begin
    def Tag.SUPERTAGS = [
  	['music','music'],
  	['performance','performance'],
  	['film','film'],
  	['spoken word','spoken word'],
  	['visual art','visual art'],
  	['activism','activism'],
  	['neighborhood','neighborhood']
  ]
=end  
  def Tag.super_and_popular
  	tags = Tag.SUPERTAGS
    	Tag.popular(20).each{|tag|
      	tags<<["#{tag.text}","##{tag.text} (#{tag.cnt})"]
    	}
    return tags
  end
  
  def Tag.find_by_prefix(prefix)
    tags = []
    puts "+++ looking for #{prefix}"
    Tag.SUPERTAGS.each{|st|
      puts "+++ st #{st[0]}"
      if st[0][prefix]
        puts "+++ found #{prefix} in #{st[0]}"
        tag = Tag.new
        tag.text=st[0]
        tags<<tag
      end
      }
    sql = <<-SQL
      select tags.*,count(*) cnt from tags,taggings,flyers where text like ?
      and tags.id=taggings.tag_id
      and taggings.flyer_id=flyers.id
      and (flyers.date>now() or flyers.end_date>now())
      group by tag_id
      order by cnt desc
      limit 7
    SQL
    tags+=Tag.find_by_sql([sql,"#{prefix}%"])
    return tags
  end
  
  def formatted_text
    if Tag.is_supertag(text)
      return text
    else
      return "##{text}"
    end
  end
  
  
  
  def Tag.is_supertag(tag)
    return nil unless tag
    Tag.SUPERTAGS.each{|st|
      return true if (st[0]==tag)
      }
    return false
  end

  def Tag.popular_within_category(category)
    limit = 5#[:limit]||50

    sql = <<-SQL
      select tags.*,count(*) cnt
      from flyers,taggings,tags
      where taggings.flyer_id=flyers.id and taggings.tag_id=tags.id
      and (flyers.created_at>adddate(now(),interval -1 year))
      and category=?
      group by tags.id
      order by cnt desc limit ?
    SQL
    return Tag.find_by_sql([sql,category,limit])
  end

  def Tag.popular(num=20)
    sql = <<-SQL
      select text,count(*) cnt from tags,taggings,flyers
      where taggings.tag_id=tags.id
      and taggings.flyer_id=flyers.id
      and flyers.date>now()
      group by text
      order by cnt desc limit ?
    SQL
    Tag.find_by_sql([sql,num])
  end

  def Tag.find_or_create(_text)
    _text.gsub!("#","")
    _text.strip!
    tag = Tag.find_by_text(_text)
    if not tag
      tag = Tag.new(:text=>_text)
      tag.save
    end
    return tag
  end
end
