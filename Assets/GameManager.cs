using System.Collections;
using System.Collections.Generic;
using UnityEngine.SceneManagement;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public GameObject gameOverOverlay;
    public string nextScene;

    public void GameOver()
    {
        Time.timeScale = 0f;
        gameOverOverlay.SetActive(true);
    }

    public void GameRetry(string thisScene)
    {
        Time.timeScale = 1f;
        SceneManager.LoadScene(SceneManager.GetActiveScene().name, LoadSceneMode.Single);
    }

    public void GameOverIn(float seconds=2f)
    {
        Invoke(nameof(GameOver), seconds);
    }

    public void LevelCompleteIn(float seconds=2f)
    {
        if (string.IsNullOrEmpty(nextScene))
        {
            GameOverIn(seconds);
        }
        else
        {
            Invoke(nameof(LoadNextScene), seconds);
        }
    }

    void LoadNextScene()
    {
        LoadScene(nextScene);
    }

    public void LoadScene(string name)
    {
        Time.timeScale = 1f;
        SceneManager.LoadScene(name, LoadSceneMode.Single);
    }
}
