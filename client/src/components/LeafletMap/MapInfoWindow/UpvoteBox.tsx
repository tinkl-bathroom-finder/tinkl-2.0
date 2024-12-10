
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


interface UpvoteBoxProps {
    user: UserType,
    bathroom: BathroomType,
}

export const UpvoteBox: React.FC<UpvoteBoxProps> = ({ bathroom, user }) => {
    const dispatch = useDispatch();

    const handleUpVote = async () => {
        let vote = 'upvote';
        if (bathroom.user_vote_status === 'upvote') vote = 'none';
        try {
            const results = await sendBathroomLike(user.id, bathroom.id, vote);
            dispatch(updateLikes(results));
        } catch (error) {
            console.log('Failed to send like:', error);
        }
    }

    const handleDownVote = async () => {
        let vote = 'downvote';
        if (bathroom.user_vote_status === 'downvote') vote = 'none';
        try {
            const results = await sendBathroomLike(user.id, bathroom.id, vote);
            dispatch(updateLikes(results))
        } catch (error) {
            console.log('Failed to send down vote', error);
        }
    }

    return (
        <>
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