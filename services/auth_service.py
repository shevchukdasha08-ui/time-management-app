from werkzeug.security import generate_password_hash, check_password_hash

class AuthService:
    @staticmethod
    def register_user(db_connection, email: str, raw_password: str, role: str = 'student'):
        """
        Hashes raw user password using Werkzeug PBKDF2:SHA256 with an automatic salt 
        before storing it in the database.
        """
        # SECURITY MEASURE: Passwords are NEVER stored in plain text.
        # PBKDF2 with SHA-256 and salt neutralizes rainbow table attacks.
        hashed_password = generate_password_hash(raw_password, method='pbkdf2:sha256', salt_length=16)
        
        # Parameterized SQL query to insert user with hashed password
        query = "INSERT INTO users (email, password_hash, role) VALUES (%s, %s, %s)"
        
        with db_connection.cursor() as cursor:
            cursor.execute(query, (email, hashed_password, role))
            db_connection.commit()
            
        return {"status": "success", "message": "User registered securely"}

    @staticmethod
    def verify_user_login(db_connection, email: str, input_password: str):
        """
        Retrieves the user record and verifies the provided raw password 
        against the stored Werkzeug hash in constant time.
        """
        query = "SELECT user_id, email, password_hash, role FROM users WHERE email = %s"
        
        with db_connection.cursor() as cursor:
            cursor.execute(query, (email,))
            user = cursor.fetchone()
            
        if not user:
            return {"status": "error", "message": "Invalid credentials"}
        
        stored_hash = user['password_hash']
        
        # Safe password verification against stored hash
        if check_password_hash(stored_hash, input_password):
            return {
                "status": "success", 
                "user": {
                    "id": user['user_id'], 
                    "email": user['email'], 
                    "role": user['role']
                }
            }
        
        return {"status": "error", "message": "Invalid credentials"}
