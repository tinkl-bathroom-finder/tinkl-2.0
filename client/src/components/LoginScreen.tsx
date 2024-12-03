import React, { useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { useNavigate } from 'react-router-dom';

//MUI
import { Button, TextField } from '@mui/material';

//Types
import { TinklRootState } from '../redux/types/TinklRootState';
import axios from 'axios';

//Actions
import { setUser } from '../redux/reducers/userReducer';

import { validateEmail } from '../modules/validateEmail';

export const LoginScreen: React.FC = () => {
    const user = useSelector((state: TinklRootState) => state.user);
    const dispatch = useDispatch();
    const navigate = useNavigate();
    const [username, setUsername] = useState<string>('');
    const [password, setPassword] = useState<string>('');
    const [emailError, setEmailError] = useState(false);
    const [passwordError, setPasswordError] = useState(false);
    const [errorMsg, setErrorMsg] = useState<string>('');
    const [isRegister, setIsRegister] = useState(false);
    const [showReset, setShowReset] = useState(false);
    const api = import.meta.env.VITE_API_BASE_URL;

    const handleLogin = () => {
        if (validateEmail(username)) {
            setEmailError(false);
            axios.post(`${api}/user/login`, { username: username, password: password })
                .then((response) => {
                    dispatch(setUser({
                        id: response.data.id,
                        username: response.data.username,
                        location: {
                            lat: user.location.lat,
                            lng: user.location.lng
                        },
                        userTime: user.userTime
                    }));
                    setEmailError(false);
                    setPasswordError(false);
                    setErrorMsg('');
                    navigate("/");
                }).catch(error => {
                    if (error.response.status === 401) {
                        setEmailError(true);
                        setErrorMsg(error.response.data.message);
                    } else {
                        setEmailError(true);
                        setPasswordError(true);
                        setErrorMsg(error.response.data);
                    }
                })
        } else {
            setEmailError(true);
        }
    }

    const handleRegister = () => {
        if (validateEmail(username)) {
            setEmailError(false);
            axios.post(`${api}/user/register`, { username: username, password: password })
                .then((response) => {
                    dispatch(setUser({
                        id: response.data.userId,
                        username: username,
                        location: {
                            lat: user.location.lat,
                            lng: user.location.lng,
                        },
                        userTime: user.userTime
                    }));
                    setEmailError(false);
                    setPasswordError(false);
                    setErrorMsg('');
                    navigate("/");
                }).catch(error => {
                    if (error.response.status === 409) {
                        setEmailError(true);
                        setPasswordError(false);
                        setErrorMsg('This username already has an account');
                    } else {
                        setEmailError(true);
                        setPasswordError(true);
                        setErrorMsg('Unable to register account');
                    }
                });

        } else {
            setEmailError(true);
        }
    }

    const setScreenToLogin = () => {
        setIsRegister(false);
        setShowReset(false);
        setEmailError(false);
        setPasswordError(false);
        setErrorMsg('');
    }

    const setScreenToRegister = () => {
        setIsRegister(true);
        setShowReset(false);
        setEmailError(false);
        setPasswordError(false);
        setErrorMsg('');
    }

    const handleForgot = () => {
        if (validateEmail(username)) {
            setEmailError(false);
            setErrorMsg('');

            axios.post(`${api}/user/forgot-password`, { username })
                .then((response) => {
                    if (response.status === 200) {
                        setErrorMsg('Password reset email sent to email address on file');
                    } else {
                        setErrorMsg('Email failed to send');
                    }
                }).catch(error => {
                    if (error.response.status === 404) {
                        setErrorMsg(error.response.data);
                        setEmailError(true);
                    } else if (error.response.status === 403) {
                        setErrorMsg(error.response.data);
                        setEmailError(true);
                    } else {
                        setErrorMsg('Error sending password reset email');
                    }
                });
        } else {
            setEmailError(true);
            setErrorMsg('Enter a valid email address');
        }
    }

    return (
        <div className="loginContainer">
            <a onClick={() => navigate('/')}>
                <img
                    style={{
                        cursor: 'pointer'
                    }}
                    className="icon"
                    src="yellow-logo.png"
                    width={120} />
            </a>
            <div id='logoHeaderText'>
                <h1 className='login-title'>tinkl</h1>
                <h2>Pee in peace.</h2>
            </div>
            <div className='loginInputContainer'>
                {errorMsg !== '' &&
                    <p className="errorMessage">{errorMsg}</p>
                }
                <TextField
                    variant='outlined'
                    required
                    label="email"
                    type='email'
                    error={emailError}
                    onChange={(event) => setUsername(event.target.value)}
                    sx={{
                        marginBottom: '1.5rem'
                    }}
                />
                <TextField
                    variant='outlined'
                    required
                    label="password"
                    type='password'
                    disabled={showReset}
                    error={passwordError}
                    onChange={(event) => setPassword(event.target.value)}
                />

                {!isRegister && !showReset &&
                    <div>
                        <Button
                            variant='contained'
                            onClick={handleLogin}
                            sx={{
                                marginTop: '1rem',
                                width: '100%'
                            }}
                        >Log In</Button>
                        <p>Don't have an account yet? <a id="registerLink" onClick={setScreenToRegister}>Register</a></p>
                        <p>Forgot password? <a id="registerLink" onClick={() => setShowReset(true)}>Click Here</a></p>
                    </div>
                }
                {isRegister && !showReset &&
                    <div>
                        <Button
                            variant='contained'
                            onClick={handleRegister}
                            sx={{
                                marginTop: '1rem',
                                width: '100%'
                            }}
                        >Register</Button>
                        <p>Already have an account? <a id="registerLink" onClick={setScreenToLogin}>Login</a></p>
                        <p>Forgot password? <a id="registerLink" onClick={() => setShowReset(true)}>Click Here</a></p>
                    </div>
                }

                {showReset &&
                    <div>
                        <Button
                            variant='contained'
                            onClick={handleForgot}
                            sx={{
                                marginTop: '1rem',
                                width: '100%',
                            }}>Reset Password</Button>
                        <p>Already have an account? <a id="registerLink" onClick={setScreenToLogin}>Login</a></p>
                        <p>Don't have an account yet? <a id="registerLink" onClick={setScreenToRegister}>Register</a></p>
                    </div>
                }
            </div>

        </div>
    )
}