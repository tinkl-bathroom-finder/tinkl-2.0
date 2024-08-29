import React, { useState } from 'react';
import { useDispatch } from 'react-redux';
import axios from 'axios';

//MUI
import { Button, TextField } from '@mui/material';

//Components
import { TinklLogo } from './tinklLogo';

//Actions
import { toggleLoginScreen } from '../redux/reducers/tinklOptionsReducer';

export const ResetPassword: React.FC = () => {
    const [password, setPassword] = useState('');
    const [confirmPassword, setConfirmPassword] = useState('');
    const [error, setError] = useState(false);
    const [errorMsg, setErrorMsg] = useState('');
    const dispatch = useDispatch();
    const api = import.meta.env.VITE_API_BASE_URL;
    const query = new URLSearchParams(location.search);
    const token = query.get('token');


    const handleConfirm = async () => {
        if (password === confirmPassword && password.length > 5) {

            axios.post(`${api}/user/reset-password/:${token}`, { password })
                .then((response) => {
                    if (response.status === 200) {
                        setErrorMsg('Password reset successfully');
                        setError(false);
                        dispatch(toggleLoginScreen());
                        window.location.replace('/');
                    }
                }).catch(error => {
                    if (error.response.status === 404) {
                        setErrorMsg(error.response.data);
                        setError(true);
                        window.location.replace('/');
                    }
                    // console.error('Error resetting password', error);
                })
        } else {
            setError(true);
            setErrorMsg('Passwords do not match');
        }
    };

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
                    label="New Password"
                    type='password'
                    error={error}
                    onChange={(event) => setPassword(event.target.value)}
                />
                <TextField
                    variant='outlined'
                    required
                    label="Confirm Password"
                    type='password'
                    error={error}
                    onChange={(event) => setConfirmPassword(event.target.value)}
                />
                <Button
                    variant='contained'
                    onClick={handleConfirm}
                    sx={{
                        marginTop: '1rem',
                        width: '100%'
                    }}
                >Confirm</Button>
            </div>
        </div>
    )
}