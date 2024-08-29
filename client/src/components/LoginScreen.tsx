import React, { useEffect, useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';

//MUI
import { Button, TextField } from '@mui/material';

//Components
import { TinklLogo } from './tinklLogo';

//Types
import { TinklRootState } from '../redux/types/TinklRootState';
import axios from 'axios';

//Actions
import { toggleLoginScreen } from '../redux/reducers/tinklOptionsReducer';
import { setUser } from '../redux/reducers/userReducer';

export const LoginScreen: React.FC = () => {
    const user = useSelector((state: TinklRootState) => state.user);
    const dispatch = useDispatch();
    const [username, setUsername] = useState<string>('');
    const [password, setPassword] = useState<string>('');
    const [emailError, setEmailError] = useState(false);
    const [passwordError, setPasswordError] = useState(false);
    const [errorMsg, setErrorMsg] = useState<string>('');
    const [isRegister, setIsRegister] = useState(false);
    const [showReset, setShowReset] = useState(false);
    const api = import.meta.env.VITE_API_BASE_URL;

    const validateEmail = (email: string) => {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }

    const handleLogin = () => {
        if (validateEmail(username)) {
            setEmailError(false);
            console.log(`${api}/user/login`);
            axios.post(`${api}/user/login`, { username: username, password: password })
                .then((response) => {
                    console.log(response);
                    dispatch(toggleLoginScreen());
                    dispatch(setUser({
                        username: username,
                        is_admin: false,
                        is_removed: false,
                        location: {
                            lat: user.location.lat,
                            lng: user.location.lng
                        }
                    }));
                    setEmailError(false);
                    setPasswordError(false);
                    setErrorMsg('');
                }).catch(error => {
                    if (error.response.status === 401) {
                        console.log(error.response);
                        setEmailError(true);
                        setErrorMsg(error.response.data.message);
                    } else {
                        setEmailError(true);
                        setPasswordError(true);
                        setErrorMsg(error.response.data);
                        console.error('Error logging in', error);
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
                    console.log(response);
                    dispatch(setUser({
                        username: username,
                        is_admin: false,
                        is_removed: false,
                        location: {
                            lat: user.location.lat,
                            lng: user.location.lng
                        }
                    }));
                    dispatch(toggleLoginScreen());
                    setEmailError(false);
                    setPasswordError(false);
                    setErrorMsg('');
                }).catch(error => {
                    if (error.response.status === 409) {
                        setEmailError(true);
                        setPasswordError(false);
                        setErrorMsg('This username already has an account');
                    } else {
                        setEmailError(true);
                        setPasswordError(true);
                        setErrorMsg('Unable to register account');
                        console.error('Error registering account', error);
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
            console.log('Reset')
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
                        console.log('Error sending password reset', error);
                    }
                });
        } else {
            setEmailError(true);
            setErrorMsg('Enter a valid email address');
        }
    }

    return (
        <div className="loginContainer">
            <div className='loginHeader'>
                <div className='logoBox'>
                    <TinklLogo width={120} height={120} />
                </div>
                <div className='logoHeaderText'>
                    <h1>tinkl</h1>
                    <h2>Pee in peace</h2>
                </div>
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
                    label="Password"
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