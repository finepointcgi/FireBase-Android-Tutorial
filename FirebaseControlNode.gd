extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Firebase = null
# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.has_singleton("Firebase"):
		Firebase = Engine.get_singleton("Firebase")
		print("got Firebase")
		if Firebase:
			Firebase.init(get_instance_id())
		Firebase.cloudmessaging_subscribe_to_topic("testtopic")
		#Firebase.authentication_google_sign_in()
	pass # Replace with function body.

func _on_firebase_receive_message(tag, from, key, data) -> void:
	print(tag, from, key, data)
	pass
	

func authUser():
	print("getting User Info")
	var user_details : String = Firebase.authentication_google_get_user()
	print("got logged data ", user_details)
	var parsed_json = JSON.parse(user_details)
	var data = parsed_json.result
	if data == null:
		return
	$UserName.text = str(data.name)
	$Email.text = str(data.email)
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed",self, "http_request_completed")
	var http_error = http_request.request(data.photo_uri)
	if http_error != OK:
		print("Unable to download user profile")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func http_request_completed(result, response_code, headers, body):
	var image = Image.new()
	var image_error = image.load_jpg_from_buffer(body)
	if image_error != OK:
		print("Unable to set user photo")
		return
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	$ProfilePhoto.texture = texture
	pass


func _on_Get_User_info_button_up():
	authUser()
	pass # Replace with function body.
