#--
# LearningStudio RESTful API Libraries 
# These libraries make it easier to use the LearningStudio Course APIs.
# Full Documentation is provided with the library. 
#
# Need Help or Have Questions? 
# Please use the PDN Developer Community at https://community.pdn.pearson.com
#
# @category   LearningStudio Course APIs
# @author     Wes Williams <wes.williams@pearson.com>
# @author     Pearson Developer Services Team <apisupport@pearson.com>
# @copyright  2014 Pearson Education Inc.
# @license    http://www.apache.org/licenses/LICENSE-2.0  Apache 2.0
# @version    1.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#++

require 'json'
require 'learning_studio_core'

module LearningStudioGrades
  class Service < LearningStudioCore::BasicService
    class Path
      COURSES_GRADEBOOK_CUSTOMCATEGORIES = "/courses/%s/gradebook/customCategories".freeze
      COURSES_GRADEBOOK_CUSTOMCATEGORIES_ = "/courses/%s/gradebook/customCategories/%s".freeze
      COURSES_GRADEBOOK_CUSTOMCATEGORIES_CUSTOMITEMS = "/courses/%s/gradebook/customCategories/%s/customItems".freeze
      COURSES_GRADEBOOK_CUSTOMCATEGORIES_CUSTOMITEMS_ = "/courses/%s/gradebook/customCategories/%s/customItems/%s".freeze
      COURSES_GRADEBOOK_CUSTOMCATEGORIES_CUSTOMITEMS_GRADEBOOKITEM = "/courses/%s/gradebook/customCategories/%s/customItems/%s/gradebookItem".freeze
      COURSES_GRADEBOOKITEMS = "/courses/%s/gradebookItems".freeze
      COURSES_GRADEBOOKITEMS_ = "/courses/%s/gradebookItems/%s".freeze
      COURSES_GRADEBOOK_GRADEBOOKITEMS_ = "/courses/%s/gradebook/gradebookItems/%s".freeze
      COURSES_GRADEBOOKITEMS_GRADES = "/courses/%s/gradebookItems/%s/grades".freeze
      COURSES_GRADEBOOKITEMS_GRADES_ = "/courses/%s/gradebookItems/%s/grades/%s".freeze
      USERS_COURSES_GRADEBOOKITEMS_GRADE = "/users/%s/courses/%s/gradebookItems/%s/grade".freeze
      USERS_COURSES_USERGRADEBOOKITEMS = "/users/%s/courses/%s/userGradebookItems".freeze
      USERS_COURSES_USERGRADEBOOKITEMS_EXPANDGRADE = USERS_COURSES_USERGRADEBOOKITEMS+"?expand=grade".freeze
      USERS_COURSES_USERGRADEBOOKITEMS_USESOURCEDOMAIN = USERS_COURSES_USERGRADEBOOKITEMS+"?useSourceDomain=true".freeze
      USERS_COURSES_USERGRADEBOOKITEMS_USESOURCEDOMAIN_EXPANDGRADE = USERS_COURSES_USERGRADEBOOKITEMS+"?useSourceDomain=true&expand=grade".freeze
      USERS_COURSES_GRADEBOOK_GRADEBOOKITEMS_GRADE = "/users/%s/courses/%s/gradebook/gradebookItems/%s/grade".freeze
      USERS_COURSES_GRADEBOOK_GRADEBOOKITEMS_GRADE_USESOURCEDOMAIN = "/users/%s/courses/%s/gradebook/gradebookItems/%s/grade?useSourceDomain=true".freeze
      USERS_COURSES_COURSEGRADETODATE = "/users/%s/courses/%s/coursegradetodate".freeze
      COURSES_GRADEBOOK_ROSTERCOURSEGRADESTODATE_STUDENTIDS_ = "/courses/%s/gradebook/rostercoursegradestodate?Student.ID=%s".freeze
      COURSES_GRADEBOOK_ROSTERCOURSEGRADESTODATE_OFFSET_LIMIT_ = "/courses/%s/gradebook/rostercoursegradestodate?offset=%s&limit=%s".freeze
      COURSES_GRADEBOOK_ROSTERCOURSEGRADESTODATE_STUDENTIDS_OFFSET_LIMIT_ = "/courses/%s/gradebook/rostercoursegradestodate?Student.ID=%s&offset=%s&limit=%s".freeze
      USERS_COURSES_GRADEBOOK_USERGRADEBOOKITEMS = "/users/%s/courses/%s/gradebook/userGradebookItems".freeze
	  USERS_COURSES_GRADEBOOK_USERGRADEBOOKITEMS_USESOURCEDOMAIN = USERS_COURSES_GRADEBOOK_USERGRADEBOOKITEMS+"?useSourceDomain=true".freeze
      USERS_COURSES_GRADEBOOK_USERGRADEBOOKITEMS_ = "/users/%s/courses/%s/gradebook/userGradebookItems/%s".freeze
      USERS_COURSES_GRADEBOOK_USERGRADEBOOKITEMS_EXPANDGRADE = USERS_COURSES_GRADEBOOK_USERGRADEBOOKITEMS_+"?expand=grade".freeze
      USERS_COURSES_GRADEBOOK_USERGRADEBOOKITEMSTOTAL = "/users/%s/courses/%s/gradebook/userGradebookItemsTotals".freeze
    end

	# Provides name of the service for identification purposes
	def self.service_identifier
	  return "LS-Library-Grade-Ruby-V1"
	end
	
    # Create custom category and item with
    #   POST /courses/:course_id/gradebook/custom_categories
    #   POST /courses/:course_id/gradebook/customCategories/:custom_category_id/customItems
    # using OAuth1 or OAuth2 as a teacher, teaching assistance or administrator.
    #
    # @param course_id [String] ID of the course.
    # @param custom_category [String] Custom category to create.
    # @param custom_item [String] Custom item to create.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.

    def create_custom_gradebook_category_and_item(course_id,
                                                  custom_category, custom_item)
      response = create_custom_gradebook_category(course_id, custom_category)
      return response if response.error?

      custom_category_object = JSON.parse(response.content)['customCategory']
      custom_category_id = custom_category_object['guid']
      response = create_custom_gradebook_item(course_id,
                                                   custom_category_id, custom_item)
      return response if response.error?

      custom_item_object = JSON.parse(response.content)['customItem']
      wrapper = {
        'customCategory' => custom_category_object,
        'customItem' => custom_item_object
      }
      response.content = wrapper.to_json
      response
    end

    # Create custom gradebook category for a course with
    #   POST /courses/:course_id/gradebook/custom_categories
    # using OAuth1 or OAuth2 as a teacher, teaching assistant or administrator.
    #
    # @param course_id [Stirng] ID of the course.
    # @param custom_category [String] Custom category to create.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def create_custom_gradebook_category(course_id, custom_category)
      post(Path::COURSES_GRADEBOOK_CUSTOMCATEGORIES % [course_id], custom_category)
    end

    # Update custom gradebook category for a course with
    #    PUT /courses/:course_id/gradebook/customCategories/:custom_category_id`
    # using OAuth1 or OAuth2 as a teacher, teaching assistant
    # or administrator.
    #
    # @param course_id [String] ID of the course.
    # @param custom_category_id [String] ID of the custom category.
    # @param custom_category [String] Custom category to create.
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def update_custom_gradebook_category(course_id, custom_category_id,
                                         custom_category)
      relative_url = Path::COURSES_GRADEBOOK_CUSTOMCATEGORIES_ % [course_id,
                                                                  custom_category_id]
      put(relative_url, custom_category)
    end

    # Delete custom gradebook category for a course with
    #   DELETE /courses/:course_id/gradebook/customCategories/:custom_category_id
    # using OAuth1 or OAuth2 as a teacher, teaching assistant
    # or administrator.
    #
    # @param course_id [String] ID of the course.
    # @param custom_category_id [String] ID of the custom category.
    #
    # @return [LearningStudioCore::Response] object with details.
    #   of status and content.
    def delete_custom_gradebook_category(course_id, custom_category_id)
      relative_url = Path::COURSES_GRADEBOOK_CUSTOMCATEGORIES_ % [course_id,
                                                                  custom_category_id]
      delete(relative_url)
    end

    # Get custom gradebook category for a course with
    #   GET /courses/:course_id/gradebook/customCategories/:custom_category_id
    # using OAuth1 or OAuth2 as a student, teacher, teaching assistant
    # or administrator.
    #
    # @param course_id [String] ID of the course.
    # @param custom_category_id [String] ID of the custom category.
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_custom_gradebook_category(course_id, custom_category_id)
      relative_url = Path::COURSES_GRADEBOOK_CUSTOMCATEGORIES_ % [course_id, custom_category_id]
      get(relative_url)
    end

	# Get custom gradebook categories for a course with
    #   GET /courses/:course_id/gradebook/customCategories
    # using OAuth1 or OAuth2 as a student, teacher, teaching assistant
    # or administrator.
    #
    # @param course_id [String] ID of the course.
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_custom_gradebook_categories(course_id)
      relative_url = Path::COURSES_GRADEBOOK_CUSTOMCATEGORIES % [course_id]
      get(relative_url)
    end
	
    # Create custom gradebook item in a custom category for a course with
    #    POST /courses/:course_id/gradebook/customCategories/:custom_category_id/customItems
    # using OAuth1 or OAuth2 as a teacher, teaching assistant
    # or administrator.
    #
    # @param course_id [String] ID of the course.
    # @param custom_category_id [String] ID of the custom category.
    # @param custom_item [String] Custom item to create.
    #
    # @return [LearningStudioCore::Response] object with details.
    #   of status and content.
    def create_custom_gradebook_item(course_id, custom_category_id,
                                     custom_item)
      relative_url = Path::COURSES_GRADEBOOK_CUSTOMCATEGORIES_CUSTOMITEMS % [course_id,
                                                                             custom_category_id]
      post(relative_url, custom_item)
    end

    # Delete custom gradebook item in a custom category for a course with
    #   DELETE /courses/:course_id/gradebook/customCategories/:custom_category_id/customItems/:custom_item_id
    # using OAuth1 or OAuth2 as a teacher, teaching assistant or administrator.
    #
    # @param course_id [String] ID of the course.
    # @param custom_category_id [String] ID of the custom category.
    # @param custom_item_id [String] ID of the custom item.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def delete_custom_gradebook_item(course_id, custom_category_id,
                                     custom_item_id)
      relative_url = Path::COURSES_GRADEBOOK_CUSTOMCATEGORIES_CUSTOMITEMS_ % [course_id,
                                                                               custom_category_id,
                                                                               custom_item_id]
      delete(relative_url)
    end

    # Get custom item in a custom gradebook category for a course with
    #   GET /courses/:course_id/gradebook/customCategories/:custom_category_id/customItems/:custom_item_id
    # using OAuth1 or OAuth2 as a teacher, teaching assistant or administrator
    #
    # @param course_id [String] ID of the course
    # @param custom_category_id [String] ID of the custom category
    # @param custom_item_id [String] ID of the custom item
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_gradebook_custom_item(course_id, custom_category_id, custom_item_id)
      relative_url = Path::COURSES_GRADEBOOK_CUSTOMCATEGORIES_CUSTOMITEMS_ % [course_id,
                                                                              custom_category_id,
                                                                              custom_item_id]
      get(relative_url)
    end

    # Get custom gradebook item in a custom category for a course with
    #   GET /courses/:course_id/gradebook/customCategories/:custom_category_id/customItems/:custom_item_id
    # using OAuth1 or OAuth2 as a teacher, teaching assistant or administrator.

    # @param course_id [String] ID of the course.
    # @param custom_category_id [String] ID of the custom category.
    # @param custom_item_id [String] ID of the custom item.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_custom_gradebook_item(course_id, custom_category_id, custom_item_id)
      relative_url = Path::COURSES_GRADEBOOK_CUSTOMCATEGORIES_CUSTOMITEMS_GRADEBOOKITEM % [course_id,
                                                                                           custom_category_id,
                                                                                           custom_item_id]
      get(relative_url)
    end

	# Get custom items in a custom category for a course with
    #   GET /courses/:course_id/gradebook/customCategories/:custom_category_id/customItems
    # using OAuth1 or OAuth2 as a student, teacher,
    # teaching assistant or administrator.
    #
    # @param course_id [String] ID of the course
	# @param custom_category_id [String] ID of the custom category.
    #
    # @return [LearningStudioCore::Response] Response object with
    #   details of status and content
    def get_custom_gradebook_items(course_id, custom_category_id)
      get(Path::COURSES_GRADEBOOK_CUSTOMCATEGORIES_CUSTOMITEMS % [course_id, custom_category_id])
    end
	
    # Get gradebook items for a course with
    #   GET /courses/:course_id/gradebookItems
    # using OAuth1 or OAuth2 as a student, teacher,
    # teaching assistant or administrator.
    #
    # @param course_id [String] ID of the course
    #
    # @return [LearningStudioCore::Response] Response object with
    #   details of status and content
    def get_gradebook_items(course_id)
      get(Path::COURSES_GRADEBOOKITEMS % [course_id])
    end

    # Get specific gradebook item for a course with
    #   GET /courses/:course_id/gradebookItems/:gradebook_item_id
    # using OAuth1 or OAuth2 as a student, teacher,
    # teaching assistant or administrator.
    #
    # @param course_id [String] ID of the course.
    # @param gradebook_item_id [String] ID of the gradebook item.
    #
    # @return [LearningStudioCore::Response] Response object with
    #   details of status and content.
    def get_gradebook_item(course_id, gradebook_item_id)
      relative_url = Path::COURSES_GRADEBOOKITEMS_ % [course_id,
                                                     gradebook_item_id]
      get(relative_url)
    end


    # Update specific gradebook item for a course with
    #   PUT /courses/:course_id/gradebook/gradebookItems/:gradebook_item_id
    # using OAuth1 or OAuth2 as a student, teacher, teaching
    # assistant or administrator
    #
    # @param course_id [String]  ID of the course
    # @param gradebook_item_id [String] ID of the gradebook item
    # @param gradebook_item [String] Details of gradebook item
    #
    # @return [LearningStudioCore::Response] Response object with
    #   details of status and content.
    def update_gradebook_item(course_id, gradebook_item_id, gradebook_item)
      relative_url = Path::COURSES_GRADEBOOK_GRADEBOOKITEMS_ % [course_id, gradebook_item_id]
      put(relative_url, gradebook_item)
    end


    # Get grades for specific gradebook item in a course using parameters with
    #   GET /courses/:course_id/gradebookItems/:gradebook_item_id/grades?gradedStudents=:graded_student_ids&useSourceDomains=true&expand=user
    # using OAuth1 or OAuth2 as a teacher, teaching assistant or administrator.
    #
    # @param course_id [String] ID of the course
    # @param gradebook_item_id [String] ID of the gradebook item
    # @param graded_student_ids [String] ID of students (semicolon separated)
    # @param use_source_domain [Boolean] Indicator of whether to include domains in urls
    # @param expand_user [Boolean] Indicator of whether to expand user info
    #
    # @return [LearningStudioCore::Response] Response object with
    #   details of status and content.
    def get_gradebook_item_grades(course_id, gradebook_item_id,
                                  graded_student_ids = nil,
                                  use_source_domain = nil,
                                  expand_user = nil)
      relative_url = Path::COURSES_GRADEBOOKITEMS_GRADES % [course_id, gradebook_item_id]
      if use_source_domain.nil?
        relative_url = update_gradebook_item_grade_relative_url(relative_url,
                                                                graded_student_ids,
                                                                use_source_domain,
                                                                expand_user)
      end

      get(relative_url)
    end

    # Get specific grade for an item in a course using parameters with
    #   GET /courses/:course_id/gradebookItems/:gradebook_item_id/grades/:grade_id?gradedStudents=:graded_student_ids&useSourceDomains=true&expand=user
    # using OAuth1 or OAuth2 as a teacher, teaching assistant or administrator
    #
    # @param course_id [String] ID of the course
    # @param gradebook_item_id [String] ID of the gradebook item
    # @param graded_student_ids [String] ID of students (semicolon separated)
    # @param grade_id ID of the grade within the gradebook
    # @param use_source_domain [Boolean] Indicator of whether to include domains in urls
    # @param expand_user [Boolean] Indicator of whether to expand user info
    #
    # @return [LearningStudioCore::Response] Response object with
    #   details of status and content.
    def get_gradebook_item_grade(course_id, gradebook_item_id, grade_id,
                                 graded_student_ids = nil, use_source_domain = nil,
                                 expand_user = nil)
      relative_url = Path::COURSES_GRADEBOOKITEMS_GRADES_ % [course_id,
                                                            gradebook_item_id,
                                                            grade_id]
      if use_source_domain.nil?
        relative_url = update_gradebook_item_grade_relative_url(relative_url,
                                                                graded_student_ids,
                                                                use_source_domain,
                                                                expand_user)
      end

      get(relative_url)
    end

    # Create user's grade for an item in a course with
    #   POST /users/:user_id/courses/:course_id/gradebookItems/:gradebook_item_id/grade
    # using OAuth1 or OAuth2 as a teacher, teaching assistant
    # or administrator.
    #
    # @param user_id [String]  ID of the user.
    # @param course_id [String]  ID of the course.
    # @param gradebook_item_id [String] ID of the gradebook item.
    # @param grade [String] Grade content to be created.
    # @return [LearningStudioCore::Response] Response object with
    #   details of status and content.
    def create_gradebook_item_grade(user_id, course_id, gradebook_item_id, grade)
      relative_url = Path::USERS_COURSES_GRADEBOOKITEMS_GRADE % [user_id, course_id, gradebook_item_id]
      post(relative_url, grade)
    end

    # Update user's grade for an item in a course with
    #   PUT /users/:user_id/courses/:course_id/gradebookItems/:gradebook_item_id/grade
    # using OAuth1 or OAuth2 as a teacher, teaching assistant
    # or administrator.
    #
    # @param user_id [String] ID of the user.
    # @param course_id [String] ID of the course.
    # @param gradebook_item_id [String] ID of the gradebook item.
    # @param grade [String] Grade content to be updated.
    #
    # @return [LearningStudioCore::Response] Response object with
    #   details of status and content.
    def update_gradebook_item_grade(user_id, course_id, gradebook_item_id, grade)
      relative_url = Path::USERS_COURSES_GRADEBOOKITEMS_GRADE % [user_id,
                                                                course_id,
                                                                gradebook_item_id]
      put(relative_url, grade)
    end

    # Delete user's grade for an item in a course with
    #   DELETE /users/:user_id/courses/:course_id/gradebookItems/:gradebook_item_id/grade
    # using OAuth1 or OAuth2 as a teacher, teaching assistant
    # or administrator.
    #
    # @param user_id [String] ID of the user.
    # @param course_id [String] ID of the course.
    # @param gradebook_item_id [String] ID of the gradebook item.
    #
    # @return [LearningStudioCore::Response] Response object with
    #   details of status and content.
    def delete_gradebook_item_grade(user_id, course_id, gradebook_item_id)
      relative_url = Path::USERS_COURSES_GRADEBOOKITEMS_GRADE % [user_id,
                                                                course_id,
                                                                gradebook_item_id]
      delete(relative_url)
    end

    # Get gradebook items for a user in a course with
    #   GET /users/:user_id/courses/:course_id/userGradebookItems
    # with optional use_source_domain and expand parameters
    # using OAuth1 or OAuth2 as a student, teacher,
    # teaching assistant or administrator
    #
    # @param user_id [String] ID of the user.
    # @param course_id [String] ID of the course.
    # @param use_source_domain [Boolean] Flag for using source
    #   domain parameter.
    # @param expand_grade [Boolean] Flag for using expand grade parameter.
    #
    # @return [LearningStudioCore::Response] Response object with
    #   details of status and content.
    def get_user_gradebook_items(user_id, course_id,
                              use_source_domain = nil, expand_grade = nil)
      if !use_source_domain.nil?
        relative_url = get_user_gradebook_items_url(use_source_domain, expand_grade) % [user_id, course_id]
      else
        relative_url = Path::USERS_COURSES_USERGRADEBOOKITEMS % [user_id, course_id]
      end
      get(relative_url)
    end

    # Create a user's grade for an item in a course with
    #   POST /users/:user_id/courses/:course_id/gradebook/gradebookItems/:gradebook_item_id/grade
    # using OAuth1 or OAuth2 as a teacher, teaching assistant or administrator
    #
    # @param user_id [String] ID of the user
    # @param course_id [String] ID of the course
    # @param gradebook_item_id [String] ID of the gradebook item
    # @param grade [String] Grade on the exam
    # @return [LearningStudioCore::Response] Response object with
    #   details of status and content.
    def create_grade(user_id, course_id, gradebook_item_id, grade)
      relative_url = Path::USERS_COURSES_GRADEBOOK_GRADEBOOKITEMS_GRADE % [user_id, course_id, gradebook_item_id]
      post(relative_url, grade)
    end

    # Update a user's grade for an item in a course with
    #   PUT /users/:user_id/courses/:course_id/gradebook/gradebookItems/:gradebook_item_id/grade
    # using OAuth1 or OAuth2 as a teacher, teaching assistant
    # or administrator.
    #
    # @param user_id [String] ID of the user.
    # @param course_id [String] ID of the course.
    # @param gradebook_item_id [String] ID of the gradebook item.
    # @param grade [String] Grade on the exam.
    # @return [LearningStudioCore::Response] Response object with
    #   details of status and content.

    def update_grade(user_id, course_id, gradebook_item_id, grade)
      relative_url = Path::USERS_COURSES_GRADEBOOK_GRADEBOOKITEMS_GRADE % [user_id, course_id, gradebook_item_id]
      put(relative_url, grade)
    end

    # Delete a user's grade for an item in a course with
    #   DELETE /users/:user_id/courses/:course_id/gradebook/gradebookItems/:gradebook_item_id/grade
    # using OAuth1 or OAuth2 as a teacher, teaching assistant
    # or administrator.
    #
    # @param user_id [String] ID of the user.
    # @param course_id [String] ID of the course.
    # @param gradebook_item_id [String] ID of the gradebook item.
    # @return [LearningStudioCore::Response] Response object with
    #   details of status and content.
    def delete_grade(user_id, course_id, gradebook_item_id)
      relative_url = Path::USERS_COURSES_GRADEBOOK_GRADEBOOKITEMS_GRADE % [user_id, course_id, gradebook_item_id]
      delete(relative_url)
    end

    # Get a user's grade for an item in a course with override for useSourceDomain with
    #   GET /users/:user_id/courses/:course_id/gradebook/gradebookItems/:gradebook_item_id/grade
    # using OAuth1 or OAuth2 as a teacher, teaching assistant
    # or administrator
    #
    # @param user_id [String] ID of the user.
    # @param course_id [String] ID of the course.
    # @param gradebook_item_id [String] ID of the gradebook item.
    # @param use_source_domain Indicator of whether to include domain in urls
    # @return [LearningStudioCore::Response] Response object with
    #   details of status and content.
    def get_grade(user_id, course_id, gradebook_item_id, use_source_domain = nil)
      relative_url = Path::USERS_COURSES_GRADEBOOK_GRADEBOOKITEMS_GRADE
      if !use_source_domain.nil?
        relative_url = get_grade_url(use_source_domain)
      end
      relative_url =  relative_url % [user_id, course_id, gradebook_item_id]
      get(relative_url)
    end

    # Get a user's grades for a course with
    #   GET /users/:user_id/courses/:course_id/gradebook/userGradebookItems
	# with optional use_source_domain parameter
    # using OAuth1 or OAuth2 as a teacher, teaching assistant, or administrator
    #
    # @param user_id [String] ID of the user.
    # @param course_id [String] ID of the course.
	# @param use_source_domain [Boolean] Flag for using source
	# domain parameter.
    # @return [LearningStudioCore::Response] Response object with
    #   details of status and content.
    def get_grades(user_id, course_id, use_source_domain = nil)
      relative_url = Path::USERS_COURSES_GRADEBOOK_USERGRADEBOOKITEMS      
	  if !use_source_domain.nil?
		relative_url = get_grades_url(use_source_domain)
	  end
	  relative_url = relative_url % [user_id, course_id]	  
	  get(relative_url)
    end

    # Get a user's current grades for a course with
    #   GET /users/:user_id/courses/:course_id/coursegradetodate
    # using OAuth1 or Auth2 as a student, teacher,
    # teaching assistant or administrator
    #
    # @param user_id [String] ID of the user.
    # @param course_id [String] ID of the course.
    # @return [LearningStudioCore::Response] Response object with
    #   details of status and content.
    def get_current_grade(user_id, course_id)
      relative_url = Path::USERS_COURSES_COURSEGRADETODATE % [user_id, course_id]
      get(relative_url)
    end

    # Get current grades for all students in a course with
    #   GET /courses/:course_id/gradebook/rostercoursegradestodate?offset=:offset&limit=:limit
    # using OAuth1 or Auth2 as a teacher, teaching assistant
    # or administrator.
    #
    # @param course_id [String] ID of the course.
    # @param student_ids [String] Comma-separated list of students to filter.
    # @param offset [String] Offset position
    # @param limit [Fixnum] Limitation on count of records.
    # @return [LearningStudioCore::Response] Response object with
    #   details of status and content.
    def get_current_grades(course_id, student_ids = nil, offset = nil, limit = nil)
      if offset.nil?
        relative_url = get_current_grades_without_offset_url(course_id, student_ids)
      elsif !student_ids.nil?
        relative_url = get_current_grades_with_offset_url(course_id, student_ids, offset, limit)
      else
        relative_url = Path::COURSES_GRADEBOOK_ROSTERCOURSEGRADESTODATE_OFFSET_LIMIT_ % [course_id,
                                                                                          offset.to_s,
                                                                                          limit.to_s]
      end
      get(relative_url)
    end

    # Get user gradebook items in a course gradebook with
    #   GET /users/:user_id/courses/:course_id/gradebook/userGradebookItems
    #   using OAuth1 or Auth2 as a student, teacher, teaching assistant or administrator
    #
    # @param user_id [String] ID of the user.
    # @param course_id [String] ID of the course.
    # @return [LearningStudioCore::Response] Response object with
    #   details of status and content.
    def get_course_gradebook_user_items(user_id, course_id)
      relative_url = Path::USERS_COURSES_GRADEBOOK_USERGRADEBOOKITEMS % [user_id, course_id]
      get(relative_url)
    end

    #
    # Get user gradebook item in a course gradebook by user gradebook item id with
    #   GET /users/:user_id/courses/:course_id/gradebook/userGradebookItems/:user_gradebook_item
    # or
    #   GET /users/:user_id/courses/:course_id/gradebook/userGradebookItems/:user_gradebook_item?expandGrade=true
    # using OAuth1 or Auth2 as a student, teacher, teaching assistant
    # or administrator.
    #
    # @param user_id [String] ID of the user.
    # @param course_id [String] ID of the course.
    # @param user_gradebook_item_id concatenation of :user_id-:gradebook_item_guid.
    # @param expand_grade [Boolean] Flag for using expand grade parameter.
    # @return [LearningStudioCore::Response] Response object with
    #   details of status and content.
    def get_course_gradebook_user_item(user_id, course_id, user_gradebook_item_id, expand_grade = nil)
      relative_url = Path::USERS_COURSES_GRADEBOOK_USERGRADEBOOKITEMS_
      if !expand_grade.nil?
        relative_url = get_course_gradebook_user_item_url(expand_grade)
      end
      relative_url = relative_url % [user_id, course_id, user_gradebook_item_id]
      get(relative_url)
    end

    # Get summary of points available to a student in a course with
    #   GET /users/:user_id/courses/:course_id/gradebook/userGradebookItemsTotals
    # using OAuth1 or Auth2 as a student, teacher, teaching assistant or administrator
    #
    # @param user_id [String] ID of the user.
    # @param course_id [String] ID of the course.
     # @return [LearningStudioCore::Response] Response object with
    #   details of status and content.
    def get_total_points_available(user_id, course_id)
      relative_url = Path::USERS_COURSES_GRADEBOOK_USERGRADEBOOKITEMSTOTAL % [user_id, course_id]
      get(relative_url)
    end

    # TODO: Optimize private methods and public methods those who call them.
    private
    def update_gradebook_item_grade_relative_url(relative_url, graded_student_ids,
                                                 use_source_domain, expand_user)
      if !graded_student_ids.nil? || use_source_domain || expand_user
        relative_url <<  '?'
        first_parameter = true
        unless !graded_student_ids.nil?
          relative_url << "gradedStudents=#{graded_student_ids}"
          first_parameter = false
        end

        if use_source_domain
          unless first_parameter
            relative_url << '&'
          end

          relative_url << "UseSourceDomain=true"
          first_parameter = false
        end

        if expand_user
          unless(first_parameter)
            relative_url << "&"
          end

          relative_url << "expand=user"
          first_parameter = false
        end
      end

      relative_url
    end

    def get_user_gradebook_items_url(use_source_domain, expandGrade)
      path = Path::USERS_COURSES_USERGRADEBOOKITEMS
      if use_source_domain || expandGrade
        if use_source_domain && expandGrade
          path = Path::USERS_COURSES_USERGRADEBOOKITEMS_USESOURCEDOMAIN_EXPANDGRADE
        elsif use_source_domain
          path = Path::USERS_COURSES_USERGRADEBOOKITEMS_USESOURCEDOMAIN
        else
          path = Path::USERS_COURSES_USERGRADEBOOKITEMS_EXPANDGRADE
        end
      end
      path
    end

    def get_grade_url(use_source_domain)
      use_source_domain ? Path::USERS_COURSES_GRADEBOOK_GRADEBOOKITEMS_GRADE_USESOURCEDOMAIN : Path::USERS_COURSES_GRADEBOOK_GRADEBOOKITEMS_GRADE
    end

	def get_grades_url(use_source_domain)
      use_source_domain ? Path::USERS_COURSES_GRADEBOOK_USERGRADEBOOKITEMS_USESOURCEDOMAIN : Path::USERS_COURSES_GRADEBOOK_USERGRADEBOOKITEMS
    end
	
    def get_current_grades_with_offset_url(course_id, student_ids, offset, limit)
      Path::COURSES_GRADEBOOK_ROSTERCOURSEGRADESTODATE_STUDENTIDS_OFFSET_LIMIT_ % [course_id,
                                                                                    student_ids,
                                                                                    offset.to_s,
                                                                                    limit.to_s]
    end

    def get_current_grades_without_offset_url(course_id, student_ids)
      Path::COURSES_GRADEBOOK_ROSTERCOURSEGRADESTODATE_STUDENTIDS_ % [course_id, student_ids]
    end

    def get_course_gradebook_user_item_url(expandGrade)
      expandGrade ? Path::USERS_COURSES_GRADEBOOK_USERGRADEBOOKITEMS_EXPANDGRADE : Path::USERS_COURSES_GRADEBOOK_USERGRADEBOOKITEMS_
    end
  end
end
