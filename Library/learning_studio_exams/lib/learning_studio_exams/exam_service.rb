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

module LearningStudioExams
  # Service for interacting with the exams module of LearningStudio
  class ExamService < LearningStudioCore::BasicService

    # Holds all relation constants
    class Relation
      USER_COURSE_EXAM = "https://api.learningstudio.com/rels/user/course/exam".freeze
    end

    # Holds all path constants
    class Path
      USERS_COURSES_ITEMS = "/users/%s/courses/%s/items".freeze

      USERS_COURSES_EXAMDETAILS = "/users/%s/courses/%s/examDetails".freeze
      USERS_COURSES_EXAMDETAILS_WITH_ID = "#{USERS_COURSES_EXAMDETAILS}/%s".freeze

      COURSES_EXAMSCHEDULES = "/courses/%s/examSchedules".freeze

      USERS_COURSES_EXAMS = "/users/%s/courses/%s/exams".freeze
      USERS_COURSES_EXAMS_WITH_ID = "#{USERS_COURSES_EXAMS}/%s".freeze

      USERS_COURSES_EXAMS_ATTEMPTS = "/users/%s/courses/%s/exams/%s/attempts"
      USERS_COURSES_EXAMS_ATTEMPTS_WITH_ID = "#{USERS_COURSES_EXAMS_ATTEMPTS}/%s"
      USERS_COURSES_EXAMS_ATTEMPTS_SUMMARY = "#{USERS_COURSES_EXAMS_ATTEMPTS_WITH_ID}/summary".freeze

      USERS_COURSES_EXAMS_SECTIONS = "/users/%s/courses/%s/exams/%s/sections".freeze
      USERS_COURSES_EXAMS_SECTIONS_QUESTIONS = "#{USERS_COURSES_EXAMS_SECTIONS}/%s/questions".freeze

      USERS_COURSES_EXAMS_SECTIONS_TRUEFALSE = "/users/%s/courses/%s/exams/%s/sections/%s/trueFalseQuestions/%s".freeze
      USERS_COURSES_EXAMS_SECTIONS_TRUEFALSE_CHOICES = "#{USERS_COURSES_EXAMS_SECTIONS_TRUEFALSE}/choices".freeze

      USERS_COURSES_EXAMS_SECTIONS_MULTIPLECHOICE = "/users/%s/courses/%s/exams/%s/sections/%s/multipleChoiceQuestions/%s".freeze
      USERS_COURSES_EXAMS_SECTIONS_MULTIPLECHOICE_CHOICES = "#{USERS_COURSES_EXAMS_SECTIONS_MULTIPLECHOICE}/choices".freeze

      USERS_COURSES_EXAMS_SECTIONS_MANYMULTIPLECHOICE = "/users/%s/courses/%s/exams/%s/sections/%s/manyMultipleChoiceQuestions/%s"
      USERS_COURSES_EXAMS_SECTIONS_MANYMULTIPLECHOICE_CHOICES = "#{USERS_COURSES_EXAMS_SECTIONS_MANYMULTIPLECHOICE}/choices"

      USERS_COURSES_EXAMS_SECTIONS_MATCHING = "/users/%s/courses/%s/exams/%s/sections/%s/matchingQuestions/%s"
      USERS_COURSES_EXAMS_SECTIONS_MATCHING_PREMISES = "#{USERS_COURSES_EXAMS_SECTIONS_MATCHING}/premises"
      USERS_COURSES_EXAMS_SECTIONS_MATCHING_CHOICES = "#{USERS_COURSES_EXAMS_SECTIONS_MATCHING}/choices"

      USERS_COURSES_EXAMS_SECTIONS_SHORT = "/users/%s/courses/%s/exams/%s/sections/%s/shortQuestions/%s"
      USERS_COURSES_EXAMS_SECTIONS_ESSAY = "/users/%s/courses/%s/exams/%s/sections/%s/essayQuestions/%s"
      USERS_COURSES_EXAMS_SECTIONS_FILLINTHEBLANK = "/users/%s/courses/%s/exams/%s/sections/%s/fillintheblankQuestions/%s"

      USERS_COURSES_EXAMS_ATTEMPTS_ANSWERS = "/users/%s/courses/%s/exams/%s/attempts/%s/answers"
      USERS_COURSES_EXAMS_ATTEMPTS_ANSWERS_WITH_ID = "/users/%s/courses/%s/exams/%s/attempts/%s/answers/%s"

    end

    class QuestionType
      TRUE_FALSE = 'trueFalse'.freeze
      MULTIPLE_CHOICE = 'multipleChoice'.freeze
      MANY_MULTIPLE_CHOICE = 'manyMultipleChoice'.freeze
      MATCHING = 'matching'.freeze
      SHORT_ANSWER = 'short'.freeze
      ESSAY = 'essay'.freeze
      FILL_IN_THE_BLANK = 'fillInTheBlank'.freeze

      VALUES = [TRUE_FALSE, MULTIPLE_CHOICE,
                MANY_MULTIPLE_CHOICE, MATCHING,
                SHORT_ANSWER, ESSAY, FILL_IN_THE_BLANK]

      def self.parse(v)
        VALUES.find{ |value| value.downcase == v.downcase }
      end
    end

    # Exam Constants.
    PEARSON_EXAM_TOKEN = 'Pearson-Exam-Token'.freeze
    PEARSON_EXAM_PASSWORD = 'Pearson-Exam-Password'.freeze

	# Provides name of the service for identification purposes
	def self.service_identifier
	  return "LS-Library-Exam-Ruby-V1"
	end
	

    # Retrieve all of a user's exams for a course with
    #   `GET /users/:user_id/courses/:course_id/items`
    #   using OAuth1 or OAuth2 as a student or teacher.
    #
    # @param user_id [String] User id
    # @param course_id [String] Course id
    # @return [LearningStudioCore::Response] object which
    #   encapsulates the exam details.
    def get_all_exam_items(user_id, course_id)
      relative_url = Path::USERS_COURSES_ITEMS % [user_id, course_id]
      response = get(relative_url)
      if !response.error?
        course_items_json = response.content
        json_obj = JSON.parse(course_items_json)
        items = json_obj['items'] || []
        exams = []
        items.each do |item|
          links = item['links'] || []
          exams << links.select { |link| Relation::USER_COURSE_EXAM == link['rel'] }
        end
        exam_items = { "items" => exams }
        response.content = exam_items.to_json
      end
      response
    end

    # Retrieve all of a user's existing exams for a course with
    #   `GET /users/:user_id/courses/:course_id/exams`
    #   using OAuth1 or OAuth2 as a student, teacher, teaching assistant or administrator
    #
    # @param user_id [String]  ID of the user
    # @param course_id [String] ID of the course
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_existing_exams(user_id, course_id)
      get(Path::USERS_COURSES_EXAMS % [user_id, course_id])
    end

    # Retrieve a user's exam for a course with
    #   `GET /users/:user_id/courses/:course_id/exams/:exam_id`
    #   using OAuth1 or OAuth2 as a student, teacher, teaching assistant or administrator
    #
    # @param user_id [String]  ID of the user
    # @param course_id [String] ID of the course
    # @param exam_id [String] ID of the exam
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_existing_exam(user_id, course_id, exam_id)
      get(Path::USERS_COURSES_EXAMS_WITH_ID % [user_id, course_id, exam_id])
    end

    # @overload get_exam_details(user_id, course_id)
    #   Retrieve details for all exams for a course with
    #     `GET /users/:user_id/courses/:course_id/exams`
    #       using OAuth1 or OAuth2 as a student, teacher,
    #       teaching assistant or administrator.
    #   @param user_id [String] ID of the user.
    #   @param course_d [String] ID of the course.
    #   @return [LearningStudioCore::Response] object which encapsulates
    #   the exam details.
    # @overload get_exam_details(user_id, course_id, exam_id)
    #   Retrive details for all exams for a course with
    #     `GET /users/:user_id/courses/:course_id/exams/:exam_id`
    #     using OAuth1 or OAuth2 as a student, teacher,
    #     teaching assistant or administrator.
    #   @param user_id [String] ID of the user.
    #   @param course_d [String] ID of the course.
    #   @param exam_id [String] ID of the exam.
    #   @return [LearningStudioCore::Response] object which encapsulates
    #   the exam details.
    def get_exam_details(user_id, course_id, exam_id = nil)
      relative_url = exam_id.nil? ?
        Path::USERS_COURSES_EXAMDETAILS % [user_id, course_id] :
        Path::USERS_COURSES_EXAMDETAILS_WITH_ID % [user_id, course_id, exam_id]

      get(relative_url)
    end

    # Retrieve exam schedules for a course with
    # `GET /courses/:course_id/examschedules` using OAuth1 or OAuth2
    #   as a teacher, teaching assistant or administrator.
    #
    # @param course_id [String] ID of the course.
    # @return [LearningStudioCore::Response] object which encapsulates
    #   exam schedules
    def get_exam_schedules(course_id)
      relative_url = Path::COURSES_EXAMSCHEDULES % [course_id]
      get(relative_url)
    end

    # Creates an exam for a user in a course with
    #   `POST /users/:user_id/courses/:course_id/exams/:exam_id`
    #   using OAuth2 as a student.
    #
    # @param user_id [String] [ID of the user.]
    # @param course_id [String] [ID of the course.]
    # @param exam_id [String] [ID of the exam.]
    # @return [LearningStudioCore::Response] object which encapsulates
    #   API response.
    def create_user_exam(user_id, course_id, exam_id)
      response = get_existing_exam(user_id, course_id,exam_id)
      if response.status_code == LearningStudioCore::BasicService::HTTPStatusCode::NOT_FOUND
        relative_url = Path::USERS_COURSES_EXAMS_WITH_ID % [user_id, course_id, exam_id]
        response = post(relative_url)
      end
      response
    end

    # Deletes an exam for a user in a course with
    #   `DELETE /users/:user_id/courses/:course_id/exams/:exam_id`
    #   using OAuth2 as a student.
    #
    # @param user_id [String] [ID of the user.]
    # @param course_id [String] [ID of the course.]
    # @param exam_id [String] [ID of the exam.]
    # @return [LearningStudioCore::Response] object which encapsulates
    #   API response.
    def delete_user_exam(user_id, course_id, exam_id)
      delete(Path::USERS_COURSES_EXAMS_WITH_ID % [user_id, course_id, exam_id])
    end

    # Create an exam attempt for a user in a course with `
    #   `POST /users/:user_id/courses/:course_id/exams/:exam_id/attempts``
    #   using OAuth1 or OAuth2 as student, teacher, teaching assistant or administrator.
    #
    # @param user_id [String] [ID of the user.]
    # @param course_id [String] [ID of the course.]
    # @param exam_id [String] [ID of the exam.]
    # @param exam_password [String] [Optional password from instructor].
    # @return [LearningStudioCore::Response] object which encapsulates
    #   API response.
    def create_exam_attempt(user_id, course_id, exam_id, exam_password = nil)
      exam_headers = {}
      exam_headers = {
        PEARSON_EXAM_PASSWORD => exam_password
      } unless exam_password.nil?
      post(Path::USERS_COURSES_EXAMS_ATTEMPTS % [user_id, course_id, exam_id], "", exam_headers)
    end

    # Retrieve a users's attempt of an exam in a course with
    #   `GET /users/:user_id/courses/:course_id/exams/:exam_id/attempts`
    #   using OAuth2 as a student
    #
    # @param user_id [String] [ID of the user.]
    # @param course_id [String] [ID of the course.]
    # @param exam_id [String] [ID of the exam.]
    # @return [LearningStudioCore::Response] object which encapsulates
    #   API response.
    def get_exam_attempts(user_id, course_id, exam_id)
      get(Path::USERS_COURSES_EXAMS_ATTEMPTS % [user_id, course_id, exam_id])
    end

    # Retrieve a user's attempt of an exam in a course with ``GET /users/:user_id/courses/:course_id/exams/:exam_id/attempts/:attempt_id``
    # using OAuth1 or OAuth2 as a student, teacher, teaching assistant or administrator.
    # @param user_id [String] ID of the user.
    # @param course_id [String] ID of the course.
    # @param exam_id [String] ID of the exam.
    # @param attempt_id [String] ID of the exam attempt.
    # @return [LearningStudioCore::Response] object which encapsulates
    #   API response.
    def get_exam_attempt(user_id, course_id, exam_id, attempt_id)
      get(Path::USERS_COURSES_EXAMS_ATTEMPTS_WITH_ID % [user_id,
                                                        course_id,
                                                        exam_id,
                                                        attempt_id])
    end

    # Retrieves and filters a user's current attempt of an exam in a course with
    #   `GET /users/:user_id/courses/:course_id/exams/:exam_id/attempts`
    #   using OAuth2 as a student.
    #
    # @param user_id [String] [ID of the user.]
    # @param course_id [String] [ID of the course.]
    # @param exam_id [String] [ID of the exam.]
    # @return [LearningStudioCore::Response] object which encapsulates
    #   API response.
    def get_current_exam_attempt(user_id, course_id, exam_id)
      response = get_exam_attempts(user_id, course_id, exam_id)
      unless response.error?
        attempts_json = response.content
        json_obj =JSON.parse(attempts_json)
        attempts = json_obj['attempts'] || []
        current_attempt = nil

        current_attempt = attempts.find { |attempt| !attempt['isCompleted'] }

        if !current_attempt.nil? && !current_attempt.empty?
          attempt = { 'attempt' => current_attempt }
          response.content = attempt.to_json
        else
          response.status_code = LearningStudioCore::BasicService::HTTPStatusCode::NOT_FOUND
          response.content = ""
        end
      end

      response
    end

    # Retrieve a summary of a user's attempt of an exam in a course with
    #   `GET /users/:user_id/courses/:course_id/exams/:exam_id/attempts/:attempt_id/summary`
    #   using OAuth2 as a student
    #
    # @param user_id [String] [ID of the user.]
    # @param course_id [String] [ID of the course.]
    # @param exam_id [String] [ID of the exam.]
    # @param attempt_id [String] [ID of the attempt.]
    # @return [LearningStudioCore::Response] object which encapsulates
    #   API response.
    def get_exam_attempt_summary(user_id, course_id, exam_id, attempt_id)
      get(Path::USERS_COURSES_EXAMS_ATTEMPTS_SUMMARY % [user_id, course_id,
                                                        exam_id, attempt_id])
    end

    # Retrieve a user's current attempt or create new attempt
    #   of an exam in a course with
    #   {#get_current_exam_attempt} and {#create_exam_attempt}
    #   using OAuth2 as a student.
    #
    # @param user_id [String] [ID of the user.]
    # @param course_id [String] [ID of the course.]
    # @param exam_id [String] [ID of the exam.]
    # @param exam_password [String] [Optional password from instructor].
    # @return [LearningStudioCore::Response] object which encapsulates
    #   API response.
    def start_exam_attempt(user_id, course_id, exam_id, exam_password = nil)
      response = get_current_exam_attempt(user_id, course_id, exam_id)
      if response.status_code == LearningStudioCore::BasicService::HTTPStatusCode::NOT_FOUND
        response = create_exam_attempt(user_id, course_id, exam_id, exam_password)
      end
      response
    end

    # Retrieve sections of an user's exam in a course with
    #   `GET /users/:user_id/courses/:course_id/exams/:exam_id/sections`
    #   using OAuth1 or OAuth2 as a student, teacher,
    #   teaching assistant or administrator.
    #
    # @param user_id [String] [ID of the user.]
    # @param course_id [String] [ID of the course.]
    # @param exam_id [String] [ID of the exam.]
    # @return [LearningStudioCore::Response] object which encapsulates
    #   API response.
    def get_exam_sections(user_id, course_id, exam_id)
      get(Path::USERS_COURSES_EXAMS_SECTIONS % [user_id, course_id, exam_id])
    end

    # Retrieve details of questions for a section of a user's exam in a course with
    #   `GET /users/:user_id/courses/:course_id/exams/:exam_id/sections/:section_id/questions`
    #   and getExamSectionQuestion using OAuth2 as a student.
    #
    # @param user_id [String] [ID of the user.]
    # @param course_id [String] [ID of the course.]
    # @param exam_id [String] [ID of the exam.]
    # @param section_id [String] [ID of the section on the exam.]
    # @return [LearningStudioCore::Response] object which encapsulates
    #   API response.
    def get_exam_section_questions(user_id, course_id, exam_id, section_id)
      relative_url = Path::USERS_COURSES_EXAMS_SECTIONS_QUESTIONS % [user_id,
                                                                     course_id, exam_id, section_id]
      response = get(relative_url)
      if !response.error?
        json_obj = JSON::parse(response.content)
        questions = json_obj['questions'] || []
        section_questions = []
        questions.each do |question|
          question_type = question['type']
          question_id = question['id']
          question_response = get_exam_section_question(user_id, course_id,
                                                        exam_id, section_id,
                                                        question_type, question_id)
          return question_response if question_response.error?

          section_question = JSON.parse(question_response.content)
		  section_question['id'] = question_id
          section_question['type'] = question_type		  
		  section_question['pointsPossible'] = question['pointsPossible']
          section_questions << section_question
        end

        response.content = { 'questions' => section_questions }.to_json
      end

      response
    end

    # Retrieve a user's answer for a question on a specific attempt of an exam in a course with
    #   `GET /users/:user_id/courses/:course_id/exams/:exam_id/attempts/:attempt_id/answers/:answer_id`
    #   using OAuth2 as a student.
    #
    # @param user_id [String] ID of the user.
    # @param course_id [String] ID of the course.
    # @param exam_id [String] ID of the exam.
    # @param attempt_id [String] ID of the attempt on the exam.
    # @param question_id [String] ID of the question on the exam.
    # @return [LearningStudioCore::Response] object which encapsulates
    #   API response.
    def get_question_answer(user_id, course_id, exam_id, attempt_id, question_id)
      response = get_exam_attempt(user_id, course_id, exam_id, attempt_id)
      return response if response.error?
      extra_headers = exam_headers(response)
      relative_url = Path::USERS_COURSES_EXAMS_ATTEMPTS_ANSWERS_WITH_ID % [user_id,
                                                                           course_id,
                                                                           exam_id,
                                                                           attempt_id,
                                                                           question_id]
      return get(relative_url, nil, extra_headers)
    end

    # Retrieve details of a question for a section of a user's exam in a course with
    # `GET /users/:user_id/courses/:course_id/exams/:exam_id/sections/:section_id/<:question_type>Questions/question_id`
    # and `GET /users/:user_id/courses/:course_id/exams/:exam_id/sections/:section_id/<:question_type>Questions/question_id/choices`
    # and `GET /users/:user_id/courses/:course_id/exams/:exam_id/sections/:section_id/<:question_type>Questions/question_id/premises`
    # using OAuth2 as a student
    #
    # @param user_id [String] [ID of the user.]
    # @param exam_id [String] [ID of the exam.]
    # @param section_id [String] [ID of the section.]
    # @param question_type [String] [Type of question.]
    # @param question_id [String] [ID of the question.]
    # @return [LearningStudioCore::Response] object which encapsulates
    #   API response.
    def get_exam_section_question(user_id, course_id, exam_id, section_id,
                                  question_type, question_id)
      qtype = QuestionType.parse(question_type)
      raise RuntimeError, "Invalid Question Type" if qtype.nil?
      response = get_current_exam_attempt(user_id, course_id, exam_id)

      return response if response.error?

      extra_headers = exam_headers(response)
      question_relative_url = choices_relative_url = premises_relative_url = nil

      case qtype
      when QuestionType::TRUE_FALSE
        question_relative_url = Path::USERS_COURSES_EXAMS_SECTIONS_TRUEFALSE % [user_id, course_id,
                                                                                exam_id, section_id,
                                                                                question_id]
        choices_relative_url = Path::USERS_COURSES_EXAMS_SECTIONS_TRUEFALSE_CHOICES % [user_id, course_id,
                                                                                       exam_id, section_id,
                                                                                       question_id]
      when QuestionType::MULTIPLE_CHOICE
        question_relative_url = Path::USERS_COURSES_EXAMS_SECTIONS_MULTIPLECHOICE % [user_id, course_id,
                                                                                     exam_id, section_id,
                                                                                     question_id]
        choices_relative_url = Path::USERS_COURSES_EXAMS_SECTIONS_MULTIPLECHOICE_CHOICES % [user_id, course_id,
                                                                                            exam_id, section_id,
                                                                                            question_id]
      when QuestionType::MANY_MULTIPLE_CHOICE
        question_relative_url = Path::USERS_COURSES_EXAMS_SECTIONS_MANYMULTIPLECHOICE % [user_id, course_id,
                                                                                         exam_id, section_id,
                                                                                         question_id]
        choices_relative_url = Path::USERS_COURSES_EXAMS_SECTIONS_MANYMULTIPLECHOICE_CHOICES % [user_id, course_id,
                                                                                                exam_id, section_id,
                                                                                                question_id]
      when QuestionType::MATCHING
        question_relative_url = Path::USERS_COURSES_EXAMS_SECTIONS_MATCHING % [user_id, course_id,
                                                                               exam_id, section_id,
                                                                               question_id]
        premises_relative_url = Path::USERS_COURSES_EXAMS_SECTIONS_MATCHING_PREMISES % [user_id, course_id,
                                                                                        exam_id, section_id,
                                                                                        question_id]
        choices_relative_url = Path::USERS_COURSES_EXAMS_SECTIONS_MATCHING_CHOICES % [user_id, course_id,
                                                                                      exam_id, section_id,
                                                                                      question_id]
      when QuestionType::SHORT_ANSWER
        question_relative_url = Path::USERS_COURSES_EXAMS_SECTIONS_SHORT % [user_id, course_id,
                                                                            exam_id, section_id,
                                                                            question_id]
      when QuestionType::ESSAY
        question_relative_url = Path::USERS_COURSES_EXAMS_SECTIONS_ESSAY  % [user_id, course_id,
                                                                             exam_id, section_id,
                                                                             question_id]
      when QuestionType::FILL_IN_THE_BLANK
        question_relative_url = Path::USERS_COURSES_EXAMS_SECTIONS_FILLINTHEBLANK % [user_id, course_id,
                                                                                     exam_id, section_id,
                                                                                     question_id]
      end

      response = get(question_relative_url, nil, extra_headers)

      return response if response.error?

      question = JSON.parse(response.content)
      details = { 'question' => question[qtype + 'Question'] }

      unless choices_relative_url.nil?
        response = get(choices_relative_url, nil, extra_headers)
        return response if response.error?
        choices = JSON.parse(response.content)
        details['choices'] = choices['choices'] || []
      end

      unless premises_relative_url.nil?
        response = get(premises_relative_url, nil, extra_headers)
        return response if response.error?
        premises = JSON.parse(response.content)
        details['premises'] = premises['premises'] || []
      end

      response.content = details.to_json
      response
    end


    # Updates a user's answer for a question on a specific attempt of an exam in a course with
    #   `GET /users/:user_id/courses/:course_id/exams/:exam_id/attempts/:attempt_id/answers/:answer_id`
    #   `POST /users/:user_id/courses/:course_id/exams/:exam_id/attempts/:attempt_id/answers`
    #   `PUT /users/:user_id/courses/:course_id/exams/:exam_id/attempts/:attempt_id/answers/:answer_id`
    #   using OAuth2 as a student.
    #
    # @param user_id [String] [ID of the user.]
    # @param course_id  [ID of the course.]
    # @param exam_id  [ID of the exam.]
    # @param attempt_id [ID of the attempt on the exam.]
    # @param question_id  [ID of the question on the exam.]
    # @param answer  [Answer to the question on the exam.]
    # @return [LearningStudioCore::Response] object with
    #   details of status and content.
    def answer_question(user_id, course_id, exam_id, attempt_id,
                        question_id, answer)
      response = self.get_current_exam_attempt(user_id, course_id, exam_id)
      return response if response.error?

      extra_headers = exam_headers(response)
      relative_url = Path::USERS_COURSES_EXAMS_ATTEMPTS_ANSWERS_WITH_ID % [user_id, course_id,
                                                                           exam_id, attempt_id,
                                                                           question_id]
      response = get(relative_url, nil, extra_headers)

      if response.error?
        if response.status_code == LearningStudioCore::BasicService::HTTPStatusCode::NOT_FOUND
          response = post(Path::USERS_COURSES_EXAMS_ATTEMPTS_ANSWERS % [user_id, course_id,
                                                                        exam_id, attempt_id],
                          answer, extra_headers)
        end
      else
        response = put(relative_url, answer, extra_headers)
      end

      response
    end

    # Delete a user's answer for a question on a specific attempt of an exam in a course with
    #   `DELETE /users/:user_id/courses/:course_id/exams/:exam_id/attempts/:attempt_id/answers/:answer_id`
    #   using OAuth2 as a student
    #
    # @param user_id [String] [ID of the user.]
    # @param course_id  [ID of the course.]
    # @param exam_id  [ID of the exam.]
    # @param attempt_id [ID of the attempt on the exam.]
    # @param question_id  [ID of the question on the exam.]
    # @return [LearningStudioCore::Response] object with
    #   details of status and content.
    def delete_question_answer(user_id, course_id, exam_id, attempt_id, question_id)
      response = get_exam_attempt(user_id, course_id, exam_id, attempt_id)
      return response if response.error?
      extra_headers = exam_headers(response)
      relative_url = Path::USERS_COURSES_EXAMS_ATTEMPTS_ANSWERS_WITH_ID % [user_id, course_id,
                                                                  exam_id, attempt_id,
                                                                  question_id]
      delete(relative_url, nil, extra_headers)
    end


    # Updates a user's attempt of an exam in a course to complete with
    #   `PUT /users/:user_id/courses/:course_id/exams/:exam_id/attempts/:attempt_id`
    #   using OAuth2 as student
    #
    # @param user_id [String] [ID of the user.]
    # @param course_id  [ID of the course.]
    # @param exam_id  [ID of the exam.]
    # @param attempt_id [ID of the attempt on the exam.]
    # @return [LearningStudioCore::Response] object with
    #   details of status and content.
    def complete_exam_attempt(user_id, course_id, exam_id, attempt_id)
      response = get_current_exam_attempt(user_id, course_id, exam_id)
      return response if response.error?
      extra_headers = exam_headers(response)
      body = {
        "attempts" => {
          "isCompleted" => true
        }
      }.to_json
      path = Path::USERS_COURSES_EXAMS_ATTEMPTS_WITH_ID % [user_id, course_id,
                                                           exam_id, attempt_id]
      put(path, body, extra_headers)
    end

    private
    def exam_headers(response)
      attempt_json = JSON.parse(response.content)
      attempt = attempt_json['attempt']
      { PEARSON_EXAM_TOKEN => attempt['pearsonExamToken'] || '' }
    end
  end
end
