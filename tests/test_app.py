from app import app


def test_home_route():
    client = app.test_client()
    response = client.get("/")
    assert response.status_code == 200


def test_members_route():
    client = app.test_client()
    response = client.get("/members")
    assert response.status_code == 200
    assert "members" in response.get_json()
