# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
comedies = Category.create(name: 'TV Comedies')
dramas = Category.create(name: 'TV Dramas')
sci_fi = Category.create(name: 'TV Sci-Fi')

the_wire = {
  title: 'The Wire',
  description: 'This series looks at the narcotics scene in Baltimore through the eyes of law enforcers as well as the drug dealers and users. Other facets of the city that are explored in the series are the government and bureaucracy, schools and the news media',
  small_cover_url: '/vid_images/thewire_small.jpg',
  large_cover_url: '/vid_images/thewire_large.jpg',
  category: dramas
}

pride_and_prejudice = {
  title: 'Pride and Prejudice',
  description: 'Jane Austen\'s classic novel about the prejudice that occurred between the 19th century classes and the pride which would keep lovers apart.',
  small_cover_url: '/vid_images/pride_and_prejudice_small.jpg',
  large_cover_url: '/vid_images/pride_and_prejudice_large.jpg',
  category: dramas
}

star_trek = {
  title: 'Star Trek',
  description: 'The iconic series "Star Trek" follows the crew of the starship USS Enterprise as it completes its missions in space in the 23rd century',
  small_cover_url: '/vid_images/star_trek_small.jpg',
  large_cover_url: '/vid_images/star_trek_large.jpg',
  category: sci_fi
}

faulty_towers = {
  title: 'Faulty Towers',
  description: 'Basil Fawlty is an inept and slightly out-of-his-head English hotel manager, who is tortured by "that annoying section of the general public who insist on staying at hotels."',
  small_cover_url: '/vid_images/faulty_towers_small.jpg',
  large_cover_url: '/vid_images/faulty_towers_large.jpg',
  category: comedies
}

fry_and_laurie = {
  title: 'A bit of Fry and Laurie',
  description: 'British comedy duo Stephen Fry and Hugh Laurie perform sketches.',
  small_cover_url: '/vid_images/fry_and_laurie_small.jpg',
  large_cover_url: '/vid_images/fry_and_laurie_large.jpg',
  category: comedies
}

[the_wire, star_trek, fry_and_laurie, pride_and_prejudice, faulty_towers]. each do |vid|
  3.times { Video.create(vid) }
end

User.create(name: 'Naveed Fida', email: 'naveedfida01@gmail.com', password: 'password')

Review.create(content: "This is a great movie isn't it", rating: 5, video: Video.find_by(title: 'A bit of Fry and Laurie'), reviewer: User.first)

Review.create(content: "This is mostly a waste of time except for a few laughs", rating: 2, video: Video.find_by(title: 'A bit of Fry and Laurie'), reviewer: User.first)
