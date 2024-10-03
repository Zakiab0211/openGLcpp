#include <GL/glut.h>
#include <string.h>

// Function to compute the width of the string in pixels
int calculateTextWidth(const char* text) {
    int width = 0;
    for (int i = 0; i < strlen(text); i++) {
        width += glutBitmapWidth(GLUT_BITMAP_HELVETICA_18, text[i]);
    }
    return width;
}

// Clears the current window and draws a rectangle with text inside it.
void display() {

    // Set every pixel in the frame buffer to the current clear color.
    glClear(GL_COLOR_BUFFER_BIT);

    // Draw a rectangle using four vertices with GL_QUADS.
    glBegin(GL_QUADS);
        glColor3f(1, 0, 0); glVertex3f(-0.6, -0.75, 0.0); // Bottom left
        glColor3f(0, 1, 0); glVertex3f(0.6, -0.75, 0.0);  // Bottom right
        glColor3f(0, 0, 1); glVertex3f(0.6, 0.75, 0.0);   // Top right
        glColor3f(1, 1, 0); glVertex3f(-0.6, 0.75, 0.0);  // Top left
    glEnd();

    // Set color for the text (white).
    glColor3f(1.0, 1.0, 1.0);

    // Text to display
    const char* message = " Hello from InfoGlobal ";

    // Calculate the width of the text
    int textWidth = calculateTextWidth(message);

    // Convert text width to normalized OpenGL coordinates
    float textPosX = -0.6 + (1.2 - textWidth / 400.0) / 2.0; // Center the text inside the rectangle
    float textPosY = -0.05; // Slightly above the vertical center of the rectangle

    // Position the text inside the rectangle.
    glRasterPos2f(textPosX, textPosY); // Set position for text (X, Y)

    // Render each character of the string using bitmap font.
    for (int i = 0; i < strlen(message); i++) {
        glutBitmapCharacter(GLUT_BITMAP_HELVETICA_18, message[i]);
    }

    // Flush drawing command buffer to make drawing happen as soon as possible.
    glFlush();
}

// Initializes GLUT, the display mode, and main window; registers callbacks;
// enters the main event loop.
int main(int argc, char** argv) {

    // Use a single buffered window in RGB mode.
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);

    // Position window at (80,80)-(480,380) and give it a title.
    glutInitWindowPosition(80, 80);
    glutInitWindowSize(600, 400);
    glutCreateWindow("infoglobal");

    // Set clear color to black.
    glClearColor(0.0, 0.0, 0.0, 0.0);

    // Tell GLUT that whenever the main window needs to be repainted, call display().
    glutDisplayFunc(display);

    // Enter the main event loop.
    glutMainLoop();
}

