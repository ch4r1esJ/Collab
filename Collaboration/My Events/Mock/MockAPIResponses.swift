//
//  MockAPIResponses.swift
//  Collaboration
//
//  Created by Rize on 23.12.25.
//


import Foundation

struct MockAPIResponses {
    
    // MARK: - Event Details Responses
    
    static let eventDetailsSuccess = """
    {
        "success": true,
        "message": "Event retrieved successfully",
        "data": {
            "id": "1",
            "title": "Leadership Workshop: Effective Communication",
            "description": "Enhance your leadership skills with this interactive workshop focusing on communication strategies, active listening, and team motivation techniques. This session is designed for new and aspiring leaders looking to build a strong foundation in effective team management and communication.",
            "banner_image_url": null,
            "tags": [
                {
                    "title": "Workshop",
                    "style": "light"
                },
                {
                    "title": "Beginner",
                    "style": "dark"
                }
            ],
            "date": "December 20, 2025",
            "start_time": "02:00 PM",
            "end_time": "04:30 PM",
            "location": "Training Room B, Building 4",
            "total_spots": 136,
            "registered_count": 129,
            "registration_deadline": "Registration closes on Dec 19, 2025 at 5:00 PM",
            "agenda": [
                {
                    "id": 1,
                    "time": "02:00 PM",
                    "title": "Welcome & Introduction",
                    "description": "Overview of the workshop goals and key topics."
                },
                {
                    "id": 2,
                    "time": "02:15 PM",
                    "title": "The Art of Active Listening",
                    "description": "Interactive exercises on understanding and responding."
                },
                {
                    "id": 3,
                    "time": "03:30 PM",
                    "title": "Q&A and Closing Remarks",
                    "description": "Open forum and summary of key takeaways."
                }
            ],
            "speakers": [
                {
                    "id": "1",
                    "name": "Sarah Johnson",
                    "title": "VP of Human Resources",
                    "image_name": "sarah"
                },
                {
                    "id": "2",
                    "name": "David Chen",
                    "title": "Lead Corporate Trainer",
                    "image_name": "david"
                }
            ]
        }
    }
    """
    
    static let eventDetailsFullyBooked = """
    {
        "success": true,
        "message": "Event retrieved successfully",
        "data": {
            "id": "2",
            "title": "Advanced Project Management",
            "description": "Take your project management skills to the next level with advanced techniques and methodologies.",
            "banner_image_url": null,
            "tags": [
                {
                    "title": "Workshop",
                    "style": "light"
                },
                {
                    "title": "Advanced",
                    "style": "dark"
                }
            ],
            "date": "January 15, 2026",
            "start_time": "10:00 AM",
            "end_time": "12:00 PM",
            "location": "Conference Hall A",
            "total_spots": 50,
            "registered_count": 50,
            "registration_deadline": "Registration closes on Jan 14, 2026 at 5:00 PM",
            "agenda": [
                {
                    "id": 1,
                    "time": "10:00 AM",
                    "title": "Introduction to Agile",
                    "description": "Understanding Agile methodology basics."
                }
            ],
            "speakers": [
                {
                    "id": "3",
                    "name": "Michael Brown",
                    "title": "Senior Project Manager",
                    "image_name": "michael_brown"
                }
            ]
        }
    }
    """
    
    static let eventNotFound = """
    {
        "success": false,
        "error": "Event not found",
        "code": 404
    }
    """
    
    // MARK: - Registration Responses
    
    static let registrationSuccess = """
    {
        "success": true,
        "message": "Successfully registered for the event",
        "registration_id": "reg_123456"
    }
    """
    
    static let registrationSuccessUpdatedEvent = """
    {
        "success": true,
        "message": "Event retrieved successfully",
        "data": {
            "id": "1",
            "title": "Leadership Workshop: Effective Communication",
            "description": "Enhance your leadership skills with this interactive workshop focusing on communication strategies, active listening, and team motivation techniques. This session is designed for new and aspiring leaders looking to build a strong foundation in effective team management and communication.",
            "banner_image_url": null,
            "tags": [
                {
                    "title": "Workshop",
                    "style": "light"
                },
                {
                    "title": "Beginner",
                    "style": "dark"
                }
            ],
            "date": "December 20, 2025",
            "start_time": "02:00 PM",
            "end_time": "04:30 PM",
            "location": "Training Room B, Building 4",
            "total_spots": 136,
            "registered_count": 130,
            "registration_deadline": "Registration closes on Dec 19, 2025 at 5:00 PM",
            "agenda": [
                {
                    "id": 1,
                    "time": "02:00 PM",
                    "title": "Welcome & Introduction",
                    "description": "Overview of the workshop goals and key topics."
                },
                {
                    "id": 2,
                    "time": "02:15 PM",
                    "title": "The Art of Active Listening",
                    "description": "Interactive exercises on understanding and responding."
                },
                {
                    "id": 3,
                    "time": "03:30 PM",
                    "title": "Q&A and Closing Remarks",
                    "description": "Open forum and summary of key takeaways."
                }
            ],
            "speakers": [
                {
                    "id": "1",
                    "name": "Sarah Johnson",
                    "title": "VP of Human Resources",
                    "image_name": "sarah_johnson"
                },
                {
                    "id": "2",
                    "name": "David Chen",
                    "title": "Lead Corporate Trainer",
                    "image_name": "david_chen"
                }
            ]
        }
    }
    """
    
    static let registrationNoSpots = """
    {
        "success": false,
        "message": "No spots available for this event",
        "registration_id": null
    }
    """
    
    static let registrationAlreadyRegistered = """
    {
        "success": false,
        "message": "You are already registered for this event",
        "registration_id": null
    }
    """
    
    static let registrationDeadlinePassed = """
    {
        "success": false,
        "message": "Registration deadline has passed",
        "registration_id": null
    }
    """
    
    // MARK: - Network/Server Errors
    
    static let networkError = """
    {
        "success": false,
        "error": "Unable to connect to server. Please check your internet connection.",
        "code": 500
    }
    """
    
    static let serverError = """
    {
        "success": false,
        "error": "Internal server error. Please try again later.",
        "code": 500
    }
    """
}
