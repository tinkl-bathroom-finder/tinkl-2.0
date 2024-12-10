import { useState } from 'react';
import { useDispatch } from 'react-redux';

//MUI
import { ThumbUp, ThumbDown, ThumbUpOutlined, ThumbDownOutlined } from '@mui/icons-material';

//Modules
import { sendBathroomLike } from '../../../modules/sendBathroomLike';
//Actions
import { updateLikes } from '../../../redux/reducers/bathroomReducer';

//Types
import { BathroomType } from "../../../redux/types/BathroomType"
import { UserType } from '../../../redux/types/UserType';
import { Snackbar } from '@mui/material';


interface UpvoteBoxProps {
    user: UserType,
    bathroom: BathroomType,
}

export const UpvoteBox: React.FC<UpvoteBoxProps> = ({ bathroom, user }) => {
    const dispatch = useDispatch();
    const [isError, setIsError] = useState(false);

    const handleUpVote = async () => {
        if (user.id === 0 || user.username === '') {
            setIsError(true);
        } else {
            let vote = 'upvote';
            if (bathroom.user_vote_status === 'upvote') vote = 'none';
            try {
                const results = await sendBathroomLike(user.id, bathroom.id, vote);
                dispatch(updateLikes(results));
            } catch (error) {
                console.log('Failed to send like:', error);
            }
        }
    }

    const handleDownVote = async () => {
        if (user.id === 0 || user.username === "") {
            setIsError(true);

        } else {
            let vote = 'downvote';
            if (bathroom.user_vote_status === 'downvote') vote = 'none';
            try {
                const results = await sendBathroomLike(user.id, bathroom.id, vote);
                dispatch(updateLikes(results))
            } catch (error) {
                console.log(error);
            }
        }
    }

    const handleClose = () => {
        setIsError(false);
    }

    return (
        <>
            <Snackbar
                open={isError}
                autoHideDuration={2000}
                onClose={handleClose}
                message="Please log in to vote!"
            />
            {bathroom.user_vote_status === 'none' &&
                <>
                    <a onClick={handleUpVote}
                        style={{
                            cursor: 'pointer',
                            color: 'inherit'
                        }}
                    >
                        <ThumbUpOutlined />{bathroom.upvotes}
                    </a>
                    <a onClick={handleDownVote}
                        style={{
                            cursor: 'pointer',
                            color: 'inherit'
                        }}
                    >
                        <ThumbDownOutlined />{bathroom.downvotes}
                    </a>
                </>
            }

            {bathroom.user_vote_status === 'upvote' &&
                <>
                    <a onClick={handleUpVote}
                        style={{
                            cursor: 'pointer',
                            color: 'inherit'
                        }}
                    >
                        <ThumbUp />{bathroom.upvotes}
                    </a>
                    <a onClick={handleDownVote}
                        style={{
                            cursor: 'pointer',
                            color: 'inherit'
                        }}
                    >
                        <ThumbDownOutlined />{bathroom.downvotes}
                    </a>
                </>
            }
            {bathroom.user_vote_status === 'downvote' &&
                <>
                    <a onClick={handleUpVote}
                        style={{
                            cursor: 'pointer',
                            color: 'inherit'
                        }}
                    >
                        <ThumbUpOutlined />{bathroom.upvotes}
                    </a>
                    <a onClick={handleDownVote}
                        style={{
                            cursor: 'pointer',
                            color: 'inherit'
                        }}
                    >
                        <ThumbDown />{bathroom.downvotes}
                    </a>
                </>
            }
        </>
    )
}