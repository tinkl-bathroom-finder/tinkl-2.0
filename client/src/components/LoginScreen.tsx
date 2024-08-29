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
                    setEmailError(true);
                    setPasswordError(true);
                    setErrorMsg('Unable to login. Check username and password or register a new account');
                    console.error('Error logging in', error);
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
                    setEmailError(false);
                    setPasswordError(false);
                    setErrorMsg('');
                }).catch(error => {
                    setEmailError(true);
                    setPasswordError(true);
                    setErrorMsg('Unable to register account');
                    console.error('Error registering account', error);
                });

        } else {
            setEmailError(true);
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
                    error={passwordError}
                    onChange={(event) => setPassword(event.target.value)}
                />
                {!isRegister &&
                    <div>
                        <Button
                            variant='contained'
                            onClick={handleLogin}
                            sx={{
                                marginTop: '1rem',
                                width: '100%'
                            }}
                        >Log In</Button>
                        <p>Don't have an account yet? <a id="registerLink" onClick={() => setIsRegister(true)}>Register</a></p>
                    </div>
                }
                {isRegister &&
                    <div>
                        <Button
                            variant='contained'
                            onClick={handleRegister}
                            sx={{
                                marginTop: '1rem',
                                width: '100%'
                            }}
                        >Register</Button>
                        <p>Already have an account? <a id="registerLink" onClick={() => setIsRegister(false)}>Login</a></p>

                    </div>
                }
            </div>

        </div>
    )
}