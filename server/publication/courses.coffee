Meteor.publish 'myCourses', ->
  return Course.find({owner: @userId})

Meteor.publish 'myCourse', (courseId) ->
  check courseId, String
  sectionsCursor = []
  lecturesCursor = []


  coursesCursor = Course.find({_id: courseId, owner: @userId})
  coursesArr = coursesCursor.fetch()
  return [] unless coursesArr.length > 0
  course = coursesArr[0]

  return [coursesCursor] unless course.sections

  sectionsCursor = Section.find({_id: {$in: course.sections}})

  sections = sectionsCursor.fetch()
  lecturesIdArr = []
  for s in sections
    Etc.pushArray(lecturesIdArr, s.lectures) if _.isArray(s.lectures)

  lecturesCursor = Lecture.find({_id: {$in: lecturesIdArr}})
  return [coursesCursor, sectionsCursor, lecturesCursor]

Meteor.publish 'popularCourses', ->
  return Course.find({}, {sort: {createdAt: -1}})

Meteor.publish 'course', (slug) ->
  check slug, String
  sectionsCursor = []
  lecturesCursor = []


  coursesCursor = Course.find({slug: slug})
  coursesArr = coursesCursor.fetch()
  return [] unless coursesArr.length > 0
  course = coursesArr[0]

  return [coursesCursor] unless course.sections

  sectionsCursor = Section.find({_id: {$in: course.sections}})

  sections = sectionsCursor.fetch()
  lecturesIdArr = []
  for s in sections
    Etc.pushArray(lecturesIdArr, s.lectures) if _.isArray(s.lectures)

  lecturesCursor = Lecture.find({_id: {$in: lecturesIdArr}})
  return [coursesCursor, sectionsCursor, lecturesCursor]
