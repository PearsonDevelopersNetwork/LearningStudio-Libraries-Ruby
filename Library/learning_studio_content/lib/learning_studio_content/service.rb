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
require 'learning_studio_core/basic_service'

module LearningStudioContent
  # An implementation of BasicService for handling the Contents API.
  class Service < LearningStudioCore::BasicService
    PATH_COURSES_ITEMS = "/courses/%s/items".freeze
    PATH_COURSES_ITEMS_ = "/courses/%s/items/%s".freeze
    PATH_COURSES_ITEMHIERARCHY = "/courses/%s/itemHierarchy".freeze
	PATH_COURSES_ITEMHIERARCHY_EXPANDITEMS = PATH_COURSES_ITEMHIERARCHY + "?expand=%s"
	PATH_COURSES_TEXTMULTIMEDIAS = "/courses/%s/textMultimedias".freeze
    PATH_COURSES_TEXTMULTIMEDIAS_CONTENTPATH_ = "/courses/%s/textMultimedias/%s/%s".freeze
    PATH_COURSES_TEXTMULTIMEDIAS_CONTENTPATH_USESOURCEDOMAIN = "/courses/%s/textMultimedias/%s/%s?useSourceDomain=true".freeze
    PATH_COURSES_TEXTMULTIMEDIAS_ = "/courses/%s/textMultimedias/%s".freeze
    PATH_COURSES_MSOFFICEDOCUMENTS = "/courses/%s/msOfficeDocuments".freeze
    PATH_COURSES_MSOFFICEDOCUMENTS_ = "/courses/%s/msOfficeDocuments/%s".freeze
    PATH_COURSES_MSOFFICEDOCUMENTS_ORIGINALDOCUMENT = "/courses/%s/msOfficeDocuments/%s/originalDocument".freeze
    PATH_COURSES_MSOFFICEDOCUMENTS_CONTENT_ = "/courses/%s/msOfficeDocuments/%s/content/%s".freeze
    PATH_COURSES_WEBCONTENTUPLOADS = "/courses/%s/webContentUploads".freeze
    PATH_COURSES_WEBCONTENTUPLOADS_ = "/courses/%s/webContentUploads/%s".freeze
    PATH_COURSES_WEBCONTENTUPLOADS_ORIGINALDOCUMENT = "/courses/%s/webContentUploads/%s/originalDocument".freeze
    PATH_COURSES_WEBCONTENTUPLOADS_CONTENT_ = "/courses/%s/webContentUploads/%s/content/%s".freeze

    PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSEHIEARCHY = "/courses/%s/threadedDiscussions/%s/topics/%s/responseHierarchy".freeze
    PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSES_RESPONSEHIEARCHY = "/courses/%s/threadedDiscussions/%s/topics/%s/responses/%s/responseHierarchy".freeze
	PATH_USERS_COURSES_ITEMS = "/users/%s/courses/%s/items"
	PATH_USERS_COURSES_ITEMHIERARCHY = "/users/%s/courses/%s/itemHierarchy"
	PATH_USERS_COURSES_ITEMHIERARCHY_EXPANDITEMS = PATH_USERS_COURSES_ITEMHIERARCHY + "?expand=%s"
    PATH_USERS_COURSES_THREADEDDISCUSSIONS_TOPICS_USERVIEWRESPONSES_USERVIEWRESPONSES = "/users/%s/courses/%s/threadedDiscussions/%s/topics/%s/userviewresponses/%s/userviewresponses".freeze
    PATH_USERS_COURSES_THREADEDDISCUSSIONS_TOPICS_USERVIEWRESPONSES_USERVIEWRESPONSES_DEPTH = PATH_USERS_COURSES_THREADEDDISCUSSIONS_TOPICS_USERVIEWRESPONSES_USERVIEWRESPONSES + "?depth=%s"
    PATH_USERS_COURSES_THREADEDDISCUSSIONS_TOPICS_USERVIEWRESPONSES = "/users/%s/courses/%s/threadedDiscussions/%s/topics/%s/userviewresponses".freeze
    PATH_USERS_COURSES_THREADEDDISCUSSIONS_TOPICS_USERVIEWRESPONSES_DEPTH = PATH_USERS_COURSES_THREADEDDISCUSSIONS_TOPICS_USERVIEWRESPONSES + "?depth=%s"

    PATH_USERS_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSES_RESPONSECOUNTS = "/users/%s/courses/%s/threadedDiscussions/%s/topics/%s/responses/%s/responseCounts".freeze
    PATH_USERS_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSES_RESPONSECOUNTS_DEPTH = PATH_USERS_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSES_RESPONSECOUNTS + "?depth=%s"
    PATH_USERS_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSECOUNTS = "/users/%s/courses/%s/threadedDiscussions/%s/topics/%s/responseCounts".freeze
    PATH_USERS_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSECOUNTS_DEPTH = PATH_USERS_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSECOUNTS + "?depth=%s"

    PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSES_RESPONSEBRANCH = "/courses/%s/threadedDiscussions/%s/topics/%s/responses/%s/responseBranch".freeze
    PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSES_RESPONSEAUTHOR = "/courses/%s/threadedDiscussions/%s/topics/%s/responses/%s/responseAuthor".freeze
    PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSES_RESPONSEANDAUTHORCOMPS = "/courses/%s/threadeddiscussions/%s/topics/%s/responses/%s/responseAndAuthorComps".freeze
    PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSES_RESPONSEANDAUTHORCOMPS_DEPTH = "/courses/%s/threadedDiscussions/%s/topics/%s/responses/%s/responseAndAuthorComps?depth=%s".freeze
    PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSEANDAUTHORCOMPS = "/courses/%s/threadedDiscussions/%s/topics/%s/responseAndAuthorComps".freeze
    PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSEANDAUTHORCOMPS_DEPTH = "/courses/%s/threadedDiscussions/%s/topics/%s/responseAndAuthorComps?depth=%s".freeze

    PATH_USERS_COURSES_THREADEDDISCUSSIONS_LASTRESPONSE = "/users/%s/courses/%s/threadedDiscussions/lastResponse".freeze
    PATH_COURSES_THREADEDDISCUSSIONS = "/courses/%s/threadedDiscussions".freeze
    PATH_COURSES_THREADEDDISCUSSIONS_USESOURCEDOMAIN = "/courses/%s/threadedDiscussions?UseSourceDomain=true".freeze
    PATH_COURSES_THREADEDDISCUSSIONS_TOPICS = "/courses/%s/threadedDiscussions/%s/topics".freeze
    PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_ = "/courses/%s/threadedDiscussions/%s/topics/%s".freeze
    PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_USESOURCEDOMAIN = "/courses/%s/threadedDiscussions/%s/topics/%s?UseSourceDomain=true".freeze

    PATH_USERS_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSE_READSTATUS = "/users/%s/courses/%s/threadedDiscussions/%s/topics/%s/responses/%s/readStatus".freeze
    PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSES_RESPONSES = "/courses/%s/threadedDiscussions/%s/topics/%s/responses/%s/responses".freeze
    PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSES_ = "/courses/%s/threadedDiscussions/%s/topics/%s/responses/%s".freeze
    PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSES = "/courses/%s/threadedDiscussions/%s/topics/%s/responses".freeze

	# Provides name of the service for identification purposes
	def self.service_identifier
	  return "LS-Library-Content-Ruby-V1"
	end
	
    # Get items for a course with
    #   GET /courses/:course_id/items
    # using OAuth1 or OAuth2 as a teacher, teaching assistant or administrator.
    #
    # @param course_id [String] ID of the course.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_items(course_id)
      relative_url = PATH_COURSES_ITEMS % [course_id]
      get(relative_url)
    end

    # Get a specific item for a course with
    #   GET /courses/:course_id/items/:item_id
    # using OAuth1 or OAuth2.
    #
    # @param course_id [String] ID of the course.
    # @param item_id [String] ID of the item.
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_item(course_id, item_id)
      relative_url = PATH_COURSES_ITEMS_ % [course_id, item_id]
      get(relative_url)
    end

	# Get content for a specific item for a course with
    #   get_item(course_id, item_id)
	# by following the links to the item itself and next to the contentUrl
    # using OAuth1 or OAuth2 as student, teacher, or teaching assistant
    #
    # @param course_id [String] ID of the course.
    # @param item_id [String] ID of the item.
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_item_content(course_id, item_id)
      relative_url = nil	
	
	  # get the item details
	  response = get_item(course_id, item_id)
	  return response if response.error?

	  json_data = JSON.parse(response.content)
	  items = json_data['items']
	  
	  if !items.nil? && items.length > 0
	    # rel on link varies, so identify self by missing title
	    links = items[0]['links']
	    links.each do |link|
		  title = link['title']
	      if title.nil?
		    relative_url = get_relative_path(link['href'])
		  end
		end
		# Get the item
	    response = get(relative_url)
	    return response if response.error?
	  
	    # Get the item content location
	    json_data = JSON.parse(response.content)
	    text_multimedias = json_data['textMultimedias']
	    content_url = text_multimedias[0]['contentUrl']		
        relative_url = get_relative_path(content_url)

        return get(relative_url)			
	  else
	    # should never get here
	    raise RuntimeError, "Unexpected condition in library: No item content path found"
	  end
    end
	
	# Get item hierarchy for a course with
    #   GET /courses/:course_id/itemHierarchy
	# or
	#	GET /courses/:course_id/itemHierarchy?expand=:expand_items
    # using OAuth1 or OAuth2 as a teacher, teaching assistant, or administrator
    #
    # @param course_id [String] ID of the course.
	# @param expand_items [String] Comma seperated list of items to expand from: 
	#	item,item.access,item.schedule,item.group
	#
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_item_hierarchy(course_id, expand_items=nil)
	  if expand_items.nil?
        relative_url = PATH_COURSES_ITEMHIERARCHY % [course_id]
	  else
	    relative_url = PATH_COURSES_ITEMHIERARCHY_EXPANDITEMS % [course_id, expand_items]
	  end
      get(relative_url)
    end
	
	# Get user item hierarchy for a course with
    #   GET /users/:user_id/courses/:course_id/itemHierarchy
	# or
    #   GET /users/:user_id/courses/:course_id/itemHierarchy?expand=:expand_items
    # using OAuth1 or OAuth2 as a student, teacher, teaching assistant, or administrator
    #
	# @param user_id [String] ID of the user.
    # @param course_id [String] ID of the course.
	# @param expand_items [String] Comma seperated list of items to expand from: 
	#	item,item.access,item.schedule,item.group
	#
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_user_item_hierarchy(user_id, course_id, expand_items=nil)
	  if expand_items.nil?
        relative_url = PATH_USERS_COURSES_ITEMHIERARCHY % [user_id, course_id]
	  else
	    relative_url = PATH_USERS_COURSES_ITEMHIERARCHY_EXPANDITEMS % [user_id, course_id, expand_items]
	  end
      get(relative_url)
    end
	
	# Get user items for a course with
    #   GET /users/:user_id/courses/:course_id/items
    # using OAuth1 or OAuth2 as a student, teacher, teaching assistant, or administrator
    #
	# @param user_id [String] ID of the user.
    # @param course_id [String] ID of the course.
	#
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_user_items(user_id, course_id)
      relative_url = PATH_USERS_COURSES_ITEMS % [user_id, course_id]
      get(relative_url)
    end
	
    # Get links details from a specific item for a course with
    #   GET /courses/:course_id/items/:item_id
    # using OAuth2 as a student, teacher or teaching assistant.
    # Note::
    # JSON structure: (Multimedia item)
    #
    #       !!!json
    #      {
    #           "details": {
    #               "access": {...},
    #               "schedule": {...},
    #               "self": {...},
    #               "selfType": "textMultimedias"
    #           }
    #       }
    #
    #
    # @param course_id [String] ID of the course.
    # @param item_id [String] ID of the item.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.

    def get_item_link_details(course_id, item_id)
      response = get_item(course_id, item_id)
      return response if response.error?

      course_items_json = response.content
      json_data = JSON.parse(course_items_json)
      items = json_data['items']
      detail = {}
      if !items.nil? && items.length > 0
        items.each do |item|
          links = item['links']
          links.each do |link|
            relative_url = get_relative_path(link['href'])
            response = get(relative_url)
            return response if response.error?
            link_element = JSON.parse(response.content)
            title = link['title']
            if title.nil?
              if !link_element.nil? && link_element.length > 0
                link_element.each do |key, value|
                  detail['self'] = value
                  detail['selfType'] = key
                  break
                end
              end
            else
              link_element = link_element[title]
              detail[title] = link_element
            end
            detail_wrapper = { 'details' => detail }
            response.content = detail_wrapper.to_json
          end
        end
      else
        raise RuntimeError, "Unexpected condition in library: No items"
      end
      response
    end

    # Get text multimedias by course with
    #   GET /courses/:course_id/textMultimedias
    # using OAuth2 as a student, teacher or teaching assistant.
    #
    # @param course_id [String] ID of the course.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_text_multimedias(course_id)
      relative_url = PATH_COURSES_TEXTMULTIMEDIAS % [course_id]
      return get(relative_url)
    end

    # Get specific text multimedia content by course with
    #   GET /courses/:course_id/textMultimedias/:text_media_id
    # using OAuth2 as a student, teacher or teaching assistant.
    #
    # @param course_id [String] ID of the course.
    # @param text_media_id [String] ID of the text media.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_text_multimedia(course_id, text_media_id)
      relative_url = PATH_COURSES_TEXTMULTIMEDIAS_ % [course_id, text_media_id]
      get(relative_url)
    end

    # Get specific text multimedia content by course with UseSourceDomain parameter with
    #   GET /courses/:course_id/textMultimedias/:text_media_id/:content_path
    # or
    #   GET /courses/:course_id/textMultimedias/:text_media_id/:content_path?UseSourceDomain=true
    # using OAuth2 as a student, teacher, or teaching assistant
    #
    # @param course_id [String] ID of the course.
    # @param text_media_id [String] ID of the item.
    # @param content_path [String] Path of content.
    # @param use_source_domain [Boolean] Indicator of whether to include domain in urls.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_text_multimedias_content(course_id, text_media_id, content_path,
                                     use_source_domain = false)
      if use_source_domain
        relative_url = PATH_COURSES_TEXTMULTIMEDIAS_CONTENTPATH_USESOURCEDOMAIN % [course_id, text_media_id, content_path]
      else
        relative_url = PATH_COURSES_TEXTMULTIMEDIAS_CONTENTPATH_ % [course_id, text_media_id, content_path]
	  end	  
      get(relative_url)
    end

	# Get specific text multimedia content by course with UseSourceDomain parameter with
    #   get_text_multimedia(course_id, text_media_id)
    # and
	#   GET /courses/:course_id/textMultimedias/:text_media_id/content_Url
	# or
    #   GET /courses/:course_id/textMultimedias/:text_media_id/content_Url?UseSourceDomain=:true
    # using OAuth2 as a student, teacher, or teaching assistant
    #
    # @param course_id [String] ID of the course.
    # @param text_media_id [String] ID of the item.
    # @param use_source_domain [Boolean] Indicator of whether to include domain in urls.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_text_multimedias_content_without_path(course_id, text_media_id, 
	                                              use_source_domain = false)
      response = get_text_multimedia(course_id, text_media_id)
	  return response if response.error?
		
      json_data = JSON.parse(response.content)
      json_data = json_data['textMultimedias'][0]
	  content_Url = json_data['contentUrl']
		
	  use_source_domain ? content_Url = content_Url + "?useSourceDomain=true" : content_Url		  
	  relative_url = get_relative_path(content_Url)
	  
      get(relative_url)
    end
	
    # Get all MS Office documents in a course with
    #   GET /courses/:course_id/msOfficeDocuments
    # using OAuth2 as a student, teacher or teaching assistant.
    #
    # @param course_id [String] ID of the course.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_ms_office_documents(course_id)
      get(PATH_COURSES_MSOFFICEDOCUMENTS % [course_id])
    end

    # Get a specific MS Office document in a course with
    #   GET /courses/:course_id/msOfficeDocuments/:ms_office_document_id
    # using OAuth2 as a student, teacher or teaching assistant.
    #
    # @param course_id [String] ID of the course.
    # @param ms_office_document_id [String] ID of the ms office document.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_ms_office_document(course_id, ms_office_document_id)
      get(PATH_COURSES_MSOFFICEDOCUMENTS_ % [course_id, ms_office_document_id])
    end

    # Get content for a specific MS Office Document in a course with
    #   GET /courses/:course_id/msOfficeDocuments/:ms_office_document_id
    # and
    #   GET /courses/:course_id/msOfficeDocuments/:ms_office_document_id/content/:content_path
    # using OAuth2 as a student, teacher or teaching assistant.
    #
    # @param course_id [String] ID of the course.
    # @param ms_office_document_id [String] ID of the ms office document.
    # @param content_path [String] Path of the content.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_ms_office_document_content(course_id, ms_office_document_id, content_path = nil)
      if content_path.nil?
        response = get_ms_office_document(course_id, ms_office_document_id)
        return response if response.error?

        json_data = JSON.parse(response.content)
        json_data = json_data['msOfficeDocuments'][0]
        contentUrl = json_data['contentUrl']
        relative_url = get_relative_path(contentUrl)
      else
        relative_url = PATH_COURSES_MSOFFICEDOCUMENTS_CONTENT_ % [course_id,
                                                                  ms_office_document_id,
                                                                  content_path]
      end
      get(relative_url)
    end

    # Get the original of a specific MS Office document in a course with
    #   GET /courses/:course_id/msOfficeDocuments/:ms_office_document_id/originalDocument
    # using OAuth2 as a student, teacher or teaching assistant.
    #
    # @param course_id [String] ID of the course.
    # @param ms_office_document_id [String] ID of the ms office document.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_ms_office_document_original(course_id, ms_office_document_id)
      relative_url = PATH_COURSES_MSOFFICEDOCUMENTS_ORIGINALDOCUMENT % [course_id,
                                                                        ms_office_document_id]
      get(relative_url)
    end

    # Get all web content uploads in a course with
    #   GET /courses/:course_id/webContentUploads
    # using OAuth2 as a student, teacher or teaching assistant
    # @param course_id [String] ID of the course.
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_web_content_uploads(course_id)
      get(PATH_COURSES_WEBCONTENTUPLOADS % [course_id])
    end

    # Get a specific MS Office document in a course with
    #   GET /courses/:course_id/webContentUploads/:web_content_upload_id
    # using OAuth2 as a student, teacher or teaching assistant.
    #
    # @param course_id [String] ID of the course.
    # @param web_content_upload_id [String] ID of the ms office document.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_web_content_upload(course_id, web_content_upload_id)
      get(PATH_COURSES_WEBCONTENTUPLOADS_ % [course_id, web_content_upload_id])
    end

    # Get a specific MS Office document in a course with
    #   GET /courses/:course_id/webContentUploads/:web_content_upload_id
    # using OAuth2 as a student, teacher or teaching assistant.
    #
    # @param course_id[String] ID of the course.
    # @param web_content_upload_id[String] ID of the ms office document.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_web_content_upload_original(course_id, web_content_upload_id)
      get(PATH_COURSES_WEBCONTENTUPLOADS_ORIGINALDOCUMENT % [course_id,
                                                             web_content_upload_id])
    end

    # Get content for a specific Web Content Upload in a course with
    #   GET /courses/:course_id/webContentUpload/:web_content_upload_id
    # and
    #   GET /courses/:course_id/webContentUpload/:web_content_upload_id}/content/:content_path
    # using OAuth2 as a student, teacher or teaching assistant.
    # @param course_id [String] ID of the course.
    # @param web_content_upload_id [String] ID of the web content upload.
    # @param content_path [String] Path of the content.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_web_content_upload_content(course_id, web_content_upload_id, content_path = nil)
      if content_path.nil?
        response = get_web_content_upload(course_id, web_content_upload_id)
        return response if response.error?
        json_data = JSON.parse(response.content)['webContentUploads'][0]
        content_url = json_data['contentUrl']
        relative_url = get_relative_path(content_url)
      else
        relative_url = PATH_COURSES_WEBCONTENTUPLOADS_CONTENT_ % [course_id,
                                                                  web_content_upload_id,
                                                                  content_path]
      end
      get(relative_url)
    end

    # Get hierarchy of a discussion thread response with
    #   GET /courses/:course_id/threadeddiscussions/:thread_id/topics/:topic_id/responses/:response_id/responseHierarchy
    # using OAuth2 as a student, teacher, teaching assistant or admin.
    #
    # @param course_id [String] ID of the course.
    # @param thread_id [String] ID of the thread.
    # @param topic_id [String] ID of the topic.
    # @param response_id [String] ID of the response.
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_threaded_discussion_response_hierarchy(course_id, thread_id,
                                                   topic_id, response_id)
      relative_url = PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSES_RESPONSEHIEARCHY % [course_id,
                                                                                           thread_id,
                                                                                           topic_id,
                                                                                           response_id]
      get(relative_url)
    end


    # Get all user's view statuses of a discussion thread response with
    #   GET /courses/:course_id/threadeddiscussions/:thread_id/topics/:topic_id/userviewresponses/{:response_id}/userviewresponses
    # or
    #   GET /courses/:course_id/threadeddiscussions/:thread_id/topics/:topic_id/userviewresponses/{:response_id}/userviewresponses?depth=:depth
    # using OAuth2 as a student.
    #
    # @param user_id[String] ID of the user.
    # @param course_id [String] ID of the course.
    # @param thread_id [String] ID of the thread.
    # @param topic_id [String] ID of the topic.
    # @param response_id [String] ID of the response.
    # @param depth [Fixnum] Number of levels to traverse.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.


    def get_threaded_discussion_user_view_responses(user_id, course_id, thread_id,
                                                    topic_id, response_id,
                                                    depth = nil)
      if depth.nil?
        relative_url = PATH_USERS_COURSES_THREADEDDISCUSSIONS_TOPICS_USERVIEWRESPONSES_USERVIEWRESPONSES % [user_id, course_id,
                                                                                                            thread_id, topic_id,
                                                                                                            response_id]
      else
        relative_url = PATH_USERS_COURSES_THREADEDDISCUSSIONS_TOPICS_USERVIEWRESPONSES_USERVIEWRESPONSES_DEPTH % [user_id, course_id,
                                                                                                                   thread_id, topic_id,
                                                                                                                   response_id, depth]
      end
      get(relative_url)
    end

    # Get all user's view statuses of a discussion thread topic with
    #   GET /courses/:course_id/threadeddiscussions/:thread_id/topics/:topic_id/userviewresponses
    # using OAuth2 as a student.
    #
    # @param user_id[String] ID of the user.
    # @param course_id [String] ID of the course.
    # @param thread_id [String] ID of the thread.
    # @param topic_id [String] ID of the topic.
    # @param depth [Fixnum] Number of levels to traverse.
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_threaded_discussion_topic_user_view_responses(user_id, course_id,
                                                          thread_id, topic_id,
                                                          depth = nil)
      if depth.nil?
        relative_url = PATH_USERS_COURSES_THREADEDDISCUSSIONS_TOPICS_USERVIEWRESPONSES % [user_id,
                                                                                          course_id,
                                                                                          thread_id,
                                                                                          topic_id]
      else
        relative_url = PATH_USERS_COURSES_THREADEDDISCUSSIONS_TOPICS_USERVIEWRESPONSES_DEPTH % [user_id,
                                                                                                 course_id,
                                                                                                 thread_id,
                                                                                                 topic_id,
                                                                                                 depth]
      end
      get(relative_url)
    end

    # Get hierarchy of a discussion thread topic with
    #   GET /courses/:course_id/threadeddiscussions/:thread_id/topics/:topic_id/responseHierarchy
    # using OAuth2 as a student, teacher, teaching assistant or admin.

    # @param course_id [String] ID of the course.
    # @param thread_id [String] ID of the thread.
    # @param topic_id [String] ID of the topic.
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_threaded_discussion_topic_hierarchy(course_id, thread_id, topic_id)
      relative_url = PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSEHIEARCHY % [course_id,
                                                                                 thread_id,
                                                                                 topic_id]
      get(relative_url)
    end

    # Get count of responses for a specific response with
    #   GET /courses/:course_id/threadeddiscussions/:thread_id/topics/:topic_id/responses/:response_id/responseCounts
    # or
    #   GET /courses/:course_id/threadeddiscussions/:thread_id/topics/:topic_id/responses/:response_id/responseCounts?depth=:depth
    # using OAuth1 or OAuth2 as a student.
    #
    # @param user_id[String] ID of the user.
    # @param course_id [String] ID of the course.
    # @param thread_id [String] ID of the thread.
    # @param topic_id [String] ID of the topic.
    # @param response_id [String] ID of the response.
    # @param depth [Fixnum] Number of levels to traverse.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_threaded_discussion_response_count(user_id, course_id, thread_id,
                                               topic_id, response_id, depth = nil)

      if depth.nil?
        relative_url = PATH_USERS_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSES_RESPONSECOUNTS % [user_id, course_id,
                                                                                                 thread_id, topic_id,
                                                                                                 response_id]
      else
        relative_url = PATH_USERS_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSES_RESPONSECOUNTS_DEPTH % [user_id, course_id,
                                                                                                        thread_id, topic_id,
                                                                                                        response_id, depth]
      end
      get(relative_url)
    end

    # Get count of responses for a specific topic with
    #   GET /courses/:course_id/threadeddiscussions/:thread_id/topics/:topic_id/responseCounts
    # or
    #   GET /courses/:course_id/threadeddiscussions/:thread_id/topics/:topic_id/responseCounts?depth=:depth
    # using OAuth1 or OAuth2 as a student.
    #
    # @param user_id [String] ID of the user.
    # @param course_id [String] ID of the course.
    # @param thread_id [String] ID of the thread.
    # @param topic_id [String] ID of the topic.
    # @param depth [Fixnum] Number of levels to traverse.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_threaded_discussion_topic_response_count(user_id, course_id, thread_id, topic_id, depth = nil)
      if depth.nil?
        relative_url = PATH_USERS_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSECOUNTS_DEPTH % [user_id, course_id, thread_id, topic_id, depth]
      else
        relative_url = PATH_USERS_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSECOUNTS % [user_id, course_id, thread_id, topic_id]
      end
      get(relative_url)
    end

    # Get branch hierarchy to a discussion thread response with
    #   GET /courses/:course_id/threadeddiscussions/:thread_id/topics/:topic_id/responses/:response_id/responseBranch
    # using OAuth1 or OAuth2 as a student, teacher, teaching assistant or admin.
    #
    # @param course_id [String] ID of the course.
    # @param thread_id [String] ID of the thread.
    # @param topic_id [String] ID of the topic.
    #
    # @param response_id [String] ID of the response
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_threaded_discussion_response_branch(course_id, thread_id,
                                                topic_id, response_id)
      relative_url = PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSES_RESPONSEBRANCH % [course_id,
                                                                                         thread_id,
                                                                                         topic_id,
                                                                                         response_id]
      get(relative_url)
    end

    # Get author of a discussion thread response with
    #   GET /courses/:course_id/threadeddiscussions/:thread_id/topics/:topic_id/responses/:response_id/responseAuthor
    # using OAuth1 or OAuth2 as a student, teacher, teaching assistant or admin.
    #
    # @param course_id [String] ID of the course.
    # @param thread_id [String] ID of the thread.
    # @param topic_id [String] ID of the topic
    # @param response_id [String] ID of the response.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_threaded_discussion_response_author(course_id, thread_id,
                                                topic_id, response_id)
      relative_url = PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSES_RESPONSEAUTHOR % [course_id,
                                                                                         thread_id,
                                                                                         topic_id,
                                                                                         response_id]
      get(relative_url)
    end

    # Get response and author composite of a discussion thread response with
    #   GET /courses/:course_id/threadeddiscussions/:thread_id/topics/:topic_id/responses/:response_id/responseAndAuthorComps
    # or
    #   GET /courses/:course_id/threadeddiscussions/:thread_id/topics/:topic_id/responses/:response_id/responseAndAuthorComps?depth=:depth
    # using OAuth1 or OAuth2 as a student, teacher, teaching assistant or admin.
    #
    # @param course_id [String] ID of the course.
    # @param thread_id [String] ID of the thread.
    # @param topic_id [String] ID of the topic.
    # @param response_id [String] ID of the response.
    # @param depth [Fixnum] Number of levels to traverse.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_threaded_discussion_response_and_author_composite(course_id,
                                                              thread_id, topic_id,
                                                              response_id, depth = nil)
      if depth.nil?
        relative_url = PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSES_RESPONSEANDAUTHORCOMPS % [course_id,
                                                                                                   thread_id,
                                                                                                   topic_id,
                                                                                                   response_id]
      else
        relative_url = PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSES_RESPONSEANDAUTHORCOMPS_DEPTH % [course_id,
                                                                                                          thread_id,
                                                                                                          topic_id,
                                                                                                          response_id,
                                                                                                          depth]
      end
      get(relative_url)
    end

    # Get response and author composite for a discussion thread topic with
    #   GET /courses/:course_id/threadeddiscussions/:thread_id/topics/:topic_id/responseAndAuthorComps/:response_id/responseAndAuthorComps
    # using OAuth1 or OAuth2 as a student, teacher, teaching assistant or admin.
    # @param course_id [String] ID of the course.
    # @param thread_id [String] ID of the thread.
    # @param topic_id [String] ID of the topic.
    # @param depth [Fixnum] Number of levels to traverse.
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_threaded_discussion_topic_response_and_author_composite(course_id,
                                                                    thread_id, topic_id,
                                                                    depth = nil)
      if depth.nil?
        relative_url = PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSEANDAUTHORCOMPS % [course_id,
                                                                                         thread_id,
                                                                                         topic_id]

      else
        relative_url = PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSEANDAUTHORCOMPS_DEPTH % [course_id,
                                                                                                thread_id,
                                                                                                topic_id,
                                                                                                depth]
      end
      get(relative_url)
    end

    # Get a user's last threaded discussion response in a course with
    #   GET /users/:user_id/courses/:course_id/threadeddiscussions/lastResponse
    # using OAuth1 or OAuth2 as a student, teacher, teaching assistant or admin.
    #
    # @param user_id [String] ID of the user.
    # @param course_id [String] ID of the course.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_last_threaded_discussion_response(user_id, course_id)
      relative_url = PATH_USERS_COURSES_THREADEDDISCUSSIONS_LASTRESPONSE % [user_id,
                                                                             course_id]
      get(relative_url)
    end

    # Get threaded dicussions for a course with
    #   GET /courses/:course_id/threadeddiscussions
    # or
    #   GET /courses/:course_id/threadeddiscussions?UseSourceDomain=:useSourceDomain
    # using OAuth1 or OAuth2 as a student, teacher, teaching assistant or admin.
    #
    # @param course_id [String] ID of the course.
    # @param use_source_domain [Boolean] Indicator of whether to use the source domain in links.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_threaded_discussions(course_id, use_source_domain = false)
      if !use_source_domain
        relative_url = PATH_COURSES_THREADEDDISCUSSIONS % [course_id]
      else
        relative_url = PATH_COURSES_THREADEDDISCUSSIONS_USESOURCEDOMAIN % [course_id]
      end

      get(relative_url)
    end

    # Get threaded dicussion topics for a course with
    #   GET /courses/:course_id/threadeddiscussions/:thread_id/topics
    # or
    #   GET /courses/:course_id/threadeddiscussions/:thread_id/topics?UseSourceDomain=:useSourceDomain
    # using OAuth1 or OAuth2 as a student, teacher, teaching assistant or admin.
    #
    # @param course_id [String] ID of the course.
    # @param thread_id [String] ID of the thread.
    # @param use_source_domain [Boolean] Indicator of whether to include domain in urls.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_threaded_discussion_topics(course_id, thread_id, use_source_domain = false)
      if !use_source_domain
        relative_url = PATH_COURSES_THREADEDDISCUSSIONS_TOPICS % [course_id, thread_id]
      else
        relative_url = PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_USESOURCEDOMAIN % [course_id, thread_id]
      end
      get(relative_url)
    end

    # Get threaded dicussion topics for a course with
    #   GET /courses/:course_id/threadeddiscussions/:thread_id/topics/:topic_id
    # or
    #   GET /courses/:course_id/threadeddiscussions/:thread_id/topics/:topic_id?UseSourceDomain=:useSourceDomain
    # using OAuth1 or OAuth2 as a student, teacher, teaching assistant or admin.
    #
    # @param course_id [String] ID of the course.
    # @param thread_id [String] ID of the thread.
    # @param topic_id [String] ID of the topic.
    # @param use_source_domain [Boolean] Indicator of whether to include domain in urls.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.

    def get_threaded_discussion_topic(course_id, thread_id, topic_id, use_source_domain = false)
      if !use_source_domain
        relative_url = PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_ %  [course_id, thread_id, topic_id]
      else
        relative_url = PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_USESOURCEDOMAIN % [course_id, thread_id, topic_id]
      end
      get(relative_url)
    end

    # Get read status of a user's discussion thread response with
    #     GET /users/:user_id/courses/:course_id/threadeddiscussions/:thread_id/topics/:topic_id/responses/:response_id/readStatus``
    # using OAuth1 or OAuth2 as a student.

    # @param user_id [String] ID of the user.
    # @param course_id [String] ID of the course.
    # @param thread_id [String] ID of the thread.
    # @param topic_id [String] ID of the topic.
    # @param response_id [String] ID of the response.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_threaded_discussion_response_read_status(user_id, course_id, thread_id, topic_id, response_id)
      relative_url = PATH_USERS_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSE_READSTATUS % [user_id, course_id, thread_id, topic_id, response_id]
      get(relative_url)
    end

    # Get read status of a user's discussion thread response with
    #   PUT /users/:user_id/courses/:course_id/threadeddiscussions/:thread_id/topics/:topic_id/responses/:response_id/readStatus
    # using OAuth1 or OAuth2 as a student.
    #
    # @param user_id [String] ID of the user.
    # @param course_id [String] ID of the course.
    # @param thread_id [String] ID of the thread.
    # @param topic_id [String] ID of the topic.
    # @param response_id [String] ID of the response.
    # @param read_status [String] Read status Message.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def update_threaded_discussion_response_read_status(user_id, course_id, thread_id,
                                                   topic_id, response_id, read_status)
      relative_url = PATH_USERS_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSE_READSTATUS % [user_id,
                                                                                          course_id,
                                                                                          thread_id,
                                                                                          topic_id,
                                                                                          response_id]
      put(relative_url, read_status)
    end

    # Get responses to a specific discussion thread response with
    #   GET /courses/:course_id/threadeddiscussions/:thread_id/topics/:topic_id/responses/:response_id/responses
    # using OAuth1 or OAuth2 as a student, teacher, teaching assistant or admin.
    # @param course_id [String] ID of the course.
    # @param thread_id [String] ID of the thread.
    # @param topic_id [String] ID of the topic.
    # @param response_id [String] ID of the response.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_threaded_discussion_responses(course_id, thread_id, topic_id, response_id)
      relative_url = PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSES_RESPONSES % [course_id,
                                                                                    thread_id,
                                                                                    topic_id,
                                                                                    response_id]
      get(relative_url)
    end

    # Create a response to a specific discussion thread response with
    #   POST /courses/:course_id/threadeddiscussions/:thread_id/topics/:topic_id/responses/:response_id/responses
    #  or
    # POST /courses/:course_id/threadeddiscussions/:thread_id/topics/:topic_id/responses
    # using OAuth2 as a student, teacher, teaching assistant or admin.
    #
    # @param course_id [String] ID of the course.
    # @param thread_id [String] ID of the thread.
    # @param topic_id [String] ID of the topic.
    # @param options [Hash] Hash with response id and response message
    # @option options [String] :response_id ID of the response.
    # @option options [String] :response_message Response message to create.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def create_threaded_discussion_response(course_id, thread_id, topic_id, options = {})
      if options[:response_id].nil?
        relative_url = PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSES % [course_id,
                                                                            thread_id,
                                                                            topic_id]
      else
        relative_url = PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSES_RESPONSES % [course_id,
                                                                                      thread_id,
                                                                                      topic_id,
                                                                                      options[:response_id]]
      end
      post(relative_url, options[:response_message])
    end


    # Update a response to a specific discussion thread response with
    #   PUT /courses/:course_id/threadeddiscussions/:thread_id/topics/:topic_id/responses/:response_id
    # using OAuth2 as a student, teacher, teaching assistant or admin.
    #
    # @param course_id [String] ID of the course.
    # @param thread_id [String] ID of the thread.
    # @param topic_id [String] ID of the topic.
    # @param response_id [String] ID of the response.
    # @param response_message [String] Response message to create.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def update_threaded_discussion_response(course_id, thread_id, topic_id,
                                         response_id, response_message)
      relative_url = PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSES_ % [course_id,
                                                                           thread_id,
                                                                           topic_id,
                                                                           response_id]
      put(relative_url, response_message)
    end

    # Get a specific discussion thread response with
    #   GET /courses/:course_id/threadeddiscussions/:thread_id/topics/:topic_id/responses/:response_id
    # using OAuth2 as a student, teacher, teaching assistant or admin.
    #
    # @param course_id [String] ID of the course.
    # @param thread_id [String] ID of the thread.
    # @param topic_id [String] ID of the topic.
    # @param response_id [String] ID of the response.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def get_threaded_discussion_response(course_id, thread_id, topic_id, response_id)

      relative_url = PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSES_ % [course_id,
                                                                           thread_id,
                                                                           topic_id,
                                                                           response_id]
      get(relative_url)
    end

    # Delete a specific discussion thread response with
    #   DELETE /courses/:course_id/threadeddiscussions/:thread_id/topics/:topic_id/responses/:response_id
    # using OAuth1 or OAuth2 as a teacher, teaching assistant or admin.
    #
    # @param course_id [String] ID of the course.
    # @param thread_id [String] ID of the thread.
    # @param topic_id [String] ID of the topic.
    # @param response_id [String] ID of the response.
    #
    # @return [LearningStudioCore::Response] object with details
    #   of status and content.
    def delete_threaded_discussion_response(course_id, thread_id, topic_id, response_id)
      relative_url = PATH_COURSES_THREADEDDISCUSSIONS_TOPICS_RESPONSES_ % [course_id,
                                                                           thread_id,
                                                                           topic_id,
                                                                           response_id]
      delete(relative_url)
    end

    private
    def get_relative_path(url)
      uri = URI.parse(url)
      path = "#{uri.path}"
      path <<  "?#{uri.query}" unless uri.query.nil?
      path
    end
  end
end
