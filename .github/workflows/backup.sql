CREATE TABLE users (
    user_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(120) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'student' NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tasks (
    task_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    priority VARCHAR(20) DEFAULT 'medium',
    status VARCHAR(20) DEFAULT 'pending',
    due_date TIMESTAMP NULL,
    CONSTRAINT fk_tasks_user FOREIGN KEY (user_id) 
        REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE habits (
    habit_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    frequency VARCHAR(20) DEFAULT 'daily',
    CONSTRAINT fk_habits_user FOREIGN KEY (user_id) 
        REFERENCES users(user_id) ON DELETE CASCADE
);

INSERT INTO users (user_id, email, password_hash, role) VALUES 
(1, 'student@university.edu', '$2b$12$e886.K9Z...', 'student'),
(2, 'admin@university.edu', '$2b$12$x992.A1M...', 'admin');

INSERT INTO tasks (task_id, user_id, title, priority, status, due_date) VALUES 
(101, 1, 'Complete Stage 2 Cybersecurity Report', 'high', 'in_progress', '2026-10-15 18:00:00'),
(102, 1, 'Prepare Database Systems Lecture Notes', 'medium', 'pending', '2026-10-18 12:00:00');

INSERT INTO habits (habit_id, user_id, title, frequency) VALUES 
(1, 1, 'Daily Task Planning', 'daily');
