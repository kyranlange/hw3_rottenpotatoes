# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(:title => movie[:title], :rating => movie[:rating], :director => movie[:director], :release_date => movie[:release_date])
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  regexp = Regexp.new ".*#{e1}.*#{e2}", Regexp::MULTILINE
  page.body.should =~ regexp
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  un = uncheck == 'un'
  whn = true
  rating_list.split(', ').each do |rating|
    if un
      if whn
        When %Q{I uncheck "ratings_#{rating}"}
        whn = false
      else
        And %Q{I uncheck "ratings_#{rating}"}
      end
    else
      if whn
        When %Q{I check "ratings_#{rating}"}
        whn = false
      else
        And %Q{I check "ratings_#{rating}"}
      end 
    end
  end
end

Then /I should see all of the movies/ do
  all("table#movies tbody tr").size.should == Movie.count
end

Then /I should see none of the movies/ do
  all("table#movies tbody tr").size.should == 0
end

Then /the director of "(.*)" should be "(.*)"/ do |title, director|
  Movie.find_by_title(title).director.should == director
end
