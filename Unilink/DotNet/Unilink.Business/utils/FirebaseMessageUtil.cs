using FirebaseAdmin;
using FirebaseAdmin.Messaging;
using Google.Apis.Auth.OAuth2;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Business.utils
{
    public static class FirebaseMessageUtil
    {
        public class MessageModel {
            public string Token { get; set; }
            public string Title { get; set; }
            public string Body { get; set; }
            public MessageModel(string token, string title, string body)
            {
                this.Token = token;
                this.Title = title;
                this.Body = body;
            }
            public Message GetMessage()
            {
                return new Message()
                {
                    Data = new Dictionary<string, string>()
                {
                    { "score", "850" },
                    { "time", "2:45" },
                },
                    Token = this.Token,
                    Notification = new Notification()
                    {
                        Title = this.Title,
                        Body = this.Body
                    }
                };
            } 
        }
        public class TopicMessageModel
        {
            public string Topic { get; set; }
            public string Title { get; set; }
            public string Body { get; set; }
            public TopicMessageModel(string topic, string title, string body)
            {
                this.Topic = topic;
                this.Title = title;
                this.Body = body;
            }
            public Message GetMessage()
            {
                return new Message()
                {
                    Data = new Dictionary<string, string>()
                {
                    { "score", "850" },
                    { "time", "2:45" },
                },
                    Topic = this.Topic,
                    Notification = new Notification()
                    {
                        Title = this.Title,
                        Body = this.Body
                    }
                };
            }
        }
        public static async Task<string>  sendMessageToOne(string token, string title, string body)
        {
            try
            {

                // This registration token comes from the client FCM SDKs.
                var registrationToken = token;

                // See documentation on defining a message payload.
                var message = new Message()
                {
                    Data = new Dictionary<string, string>()
            {
                { "score", "850" },
                { "time", "2:45" },
            },
                    Token = registrationToken,
                    Notification = new Notification()
                    {
                        Title = title,
                        Body = body
                    }
                };

                // Send a message to the device corresponding to the provided
                // registration token.
                string response = await FirebaseMessaging.DefaultInstance.SendAsync(message);
                // Response is a message ID string.
                return response;
            } catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
        public static async Task<string> sendMessageToTopic(string topic, string title, string body)
        {
            try
            {

                // This registration token comes from the client FCM SDKs.

                // See documentation on defining a message payload.
                var message = new Message()
                {
                    Data = new Dictionary<string, string>()
                    {
                        { "score", "850" },
                        { "time", "2:45" },
                    },
                    Topic = topic,
                    Notification = new Notification()
                    {
                        Title = title,
                        Body = body
                    }
                };

                // Send a message to the device corresponding to the provided
                // registration token.
                string response = await FirebaseMessaging.DefaultInstance.SendAsync(message);
                // Response is a message ID string.
                return response;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
        public static async Task<dynamic> sendBatchMessage(List<Message> MessageList)
        {
            try
            {

                // This registration token comes from the client FCM SDKs.

                // See documentation on defining a message payload.
                var message = MessageList;

                // Send a message to the device corresponding to the provided
                // registration token.
                var response = await FirebaseMessaging.DefaultInstance.SendAllAsync(message);
                // Response is a message ID string.
                return response;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

    }
}
