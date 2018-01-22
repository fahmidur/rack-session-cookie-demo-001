# A Simple Rack-Session-Cookie Demo

This repo was created in order to help a friend understand Rack::Session::Cookie.

To play with it properly, it is recommended that you install some JSON viewer extension
in your browser like: [JSON Formatter](https://chrome.google.com/webstore/detail/json-formatter/bcjindcccaagfpapjjmafapmmgkkhgoa?hl=en)

This server is only meant to run locally in order to demonstrate
and play with Rack::Session::Cookie

## Starting The Server Locally

Starts by default on port 9292
```bash
rackup
```

or if you would rather start on a particular port...

```bash
rackup -p [PORT]
```
## Server Routes

All requests made to the server are to be HTTP request methods of the GET type. In trying to understand Cookies and Sessions which are stored on the cookie, it is not my intention to confuse the learner by introducing different HTTP request methods into the mix, such a concept is not useful or conducive to learning about cookies.


All requests will create a "session" if one does not exist.

### Every Request

Before we describe the routes. It is important to note that every route will always answer with the same basic data. Every route will respond with success or failure indicator and data representing the current 'state' of things. Remember that HTTP is a stateless protocol and sessions are there to create/store state.

Sample Response:


```json
{
	"ok": true,
	"data": {
		"cookies_bef": {
			"rack.session": "BAh7CkkiD3Nlc3Npb25faWQGOgZFVEkiRWViYjUzYmFkMWY4N2JlYWI1NWIw\nZDhkMGY4MjI1ZWQyM2EwN2Y2MTA0ODA3YjFkNWVkMjg1NzQ2NjcwMGYxZjMG\nOwBGSSIJY3NyZgY7AEZJIjFmNU03R3VGZXBJTTBDKzJZOGo4MVhmUE9KMXpT\nSTgzWWkrK1oyQmRiK1pBPQY7AEZJIg10cmFja2luZwY7AEZ7B0kiFEhUVFBf\nVVNFUl9BR0VOVAY7AFRJIi0yYWY5YTdjNTA0MzQ1MDE2YzZmZGJlYzI0Y2My\nMzM5MjlhODllNTJmBjsARkkiGUhUVFBfQUNDRVBUX0xBTkdVQUdFBjsAVEki\nLWQ0ZTdkMzNmNGViNzNiY2U4ZmY3MDdjODBiNjlhYzU3ZWU1YzlmYmMGOwBG\nSSIbU0VTU0lPTl9URVNUX3RpbWVzdGFtcAY7AFRJIhl0ZXN0dmFsdWVfMTUx\nNjY2NTY2NAY7AFRJIhtTRVNTSU9OX1RFU1RfcGFnZXZpZXdzBjsAVH0GSSIG\nLwY7AFRpGWkA\n--bd89c1ffc02c339b488cba10b08948502ea5ee07"
		},
		"cookies_cur": {
			"rack.session": "BAh7CkkiD3Nlc3Npb25faWQGOgZFVEkiRWViYjUzYmFkMWY4N2JlYWI1NWIw\nZDhkMGY4MjI1ZWQyM2EwN2Y2MTA0ODA3YjFkNWVkMjg1NzQ2NjcwMGYxZjMG\nOwBGSSIJY3NyZgY7AEZJIjFmNU03R3VGZXBJTTBDKzJZOGo4MVhmUE9KMXpT\nSTgzWWkrK1oyQmRiK1pBPQY7AEZJIg10cmFja2luZwY7AEZ7B0kiFEhUVFBf\nVVNFUl9BR0VOVAY7AFRJIi0yYWY5YTdjNTA0MzQ1MDE2YzZmZGJlYzI0Y2My\nMzM5MjlhODllNTJmBjsARkkiGUhUVFBfQUNDRVBUX0xBTkdVQUdFBjsAVEki\nLWQ0ZTdkMzNmNGViNzNiY2U4ZmY3MDdjODBiNjlhYzU3ZWU1YzlmYmMGOwBG\nSSIbU0VTU0lPTl9URVNUX3RpbWVzdGFtcAY7AFRJIhl0ZXN0dmFsdWVfMTUx\nNjY2NTY2NAY7AFRJIhtTRVNTSU9OX1RFU1RfcGFnZXZpZXdzBjsAVH0GSSIG\nLwY7AFRpGWkA\n--bd89c1ffc02c339b488cba10b08948502ea5ee07"
		},
		"cookies_aft": {
			"rack.session": "BAh7CkkiD3Nlc3Npb25faWQGOgZFVEkiRTEwMTdmODExZTNlZjU0MzVmOTU5%0AYzUwOTJkY2JmN2MxMzU5ZjAxYjQ2OTc4OTc5MzUzZTM0MzJkYmQ3OTU5MmYG%0AOwBGSSIJY3NyZgY7AEZJIjFUcG82SVhoM1dWZW5KVGpZOHFFQ3Q0RURjNm12%0AZXlacW1lNTN0ZVNhRklFPQY7AEZJIg10cmFja2luZwY7AEZ7B0kiFEhUVFBf%0AVVNFUl9BR0VOVAY7AFRJIi0yYWY5YTdjNTA0MzQ1MDE2YzZmZGJlYzI0Y2My%0AMzM5MjlhODllNTJmBjsARkkiGUhUVFBfQUNDRVBUX0xBTkdVQUdFBjsAVEki%0ALWQ0ZTdkMzNmNGViNzNiY2U4ZmY3MDdjODBiNjlhYzU3ZWU1YzlmYmMGOwBG%0ASSIbU0VTU0lPTl9URVNUX3RpbWVzdGFtcAY7AFRJIhl0ZXN0dmFsdWVfMTUx%0ANjY2NjY4NwY7AFRJIhtTRVNTSU9OX1RFU1RfcGFnZXZpZXdzBjsAVH0GSSIG%0ALwY7AFRpBmkA%0A--60d5c1305bd777908e0efbdf709777ebce156b24"
		},
		"session_bef": {
			"session_id": "1017f811e3ef5435f959c5092dcbf7c1359f01b46978979353e3432dbd79592f",
			"csrf": "Tpo6IXh3WVenJTjY8qECt4EDc6mveyZqme53teSaFIE=",
			"tracking": {
				"HTTP_USER_AGENT": "2af9a7c504345016c6fdbec24cc233929a89e52f",
				"HTTP_ACCEPT_LANGUAGE": "d4e7d33f4eb73bce8ff707c80b69ac57ee5c9fbc"
			},
			"SESSION_TEST_timestamp": "testvalue_1516666687",
			"SESSION_TEST_pageviews": {
				"/": 1
			}
		},
		"session_cur": {
			"session_id": "1017f811e3ef5435f959c5092dcbf7c1359f01b46978979353e3432dbd79592f",
			"csrf": "Tpo6IXh3WVenJTjY8qECt4EDc6mveyZqme53teSaFIE=",
			"tracking": {
				"HTTP_USER_AGENT": "2af9a7c504345016c6fdbec24cc233929a89e52f",
				"HTTP_ACCEPT_LANGUAGE": "d4e7d33f4eb73bce8ff707c80b69ac57ee5c9fbc"
			},
			"SESSION_TEST_timestamp": "testvalue_1516666687",
			"SESSION_TEST_pageviews": {
				"/": 1
			}
		}
	},
	"params": {
		"captures": []
	}
}
```

Every request here will respond with boolean key 'ok' indicating success or failure. This is a personal convention, but not entirely without some validation from other projects (like Slack). I started doing this ok-true ok-false thing a long time ago. I prefer 'ok' over something like 'success' because it is shorter, and you're much less likely to accidentally type 'sucess' or any other alternate spelling -- it's pretty hard to mistype 'ok'. 

Moving on, this you'll notice that the bulk of the response is all within a 'data' key. Within this you'll find 3 keys for the Cookie and 2 for the session.

#### The 3 Cookie Keys and What They Mean
* **cookies_bef** - Contains a map representing all cookies. This is parsed from the 'cookie' header in the request.
* **cookies_cur** - Contains a map representing all the cookies at the time the request is answered, during response. This will make more sense when we see the other routes which will let you the user alter the cookies (play with it). 
* **cookies_aft** -- Contains a map representing the cookie that is being returned in the response. This is parsed from the Set-Cookie header in the response. Notice that Set-Cookie returns a nil value for a key when it wants to delete an entry.

#### The 2 Session Keys and What They Mean
* **session_bef** - Contains a map with all of the key-value pairs stored in the session. This is captured before any changes are made to the session. Notice nesting is allowed.
* **session_cur** - Contains a map with all of the key-value pairs stored in the session. This is captured at the time of the response after changes are made to the session. Notice what changes. This will made more sense when we see the routes that let you change what is stored in the session (play with it).

### GET / 
View The Current State.
Does nothing takes no action, only creates a session if one does not exist.

### GET /session/clear 
Clear the session.

### GET /session/set?key=key&val=val
Expects params[:key] and params[:val]. Adds a new key-value pair into the session, or overwrites if the key exists.

### GET /session/del?key=key
Expects params[:key] and deletes the key from the session

### GET /cookies/clear
Clears all cookies. Notice however that the session id gets written back.

### GET /cookies/set?key=key&val=val
Expects params[:key] and params[:val].
Creates a new Cookie with key=val

### GET /cookies/del?key=key
Expects params[:key].
Deletes a cookie with key=key
